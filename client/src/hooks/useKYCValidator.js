import { useContract } from './useContract';
// import C_TOKEN_ABI from '../static/cEthABI';
import KYC_VALIDATOR_ABI from '../contracts/KYCValidatorChainlink.json';
import useIsValidNetwork from './useIsValidNetwork';
import { useWeb3React } from '@web3-react/core';
import { useAppContext } from '../AppContext';
import { formatUnits, parseEther } from '@ethersproject/units';
import { useEffect } from 'react';

export const useKYCValidator = () => {
  const { account } = useWeb3React();
  const { isValidNetwork } = useIsValidNetwork();
  const validator = account;
  const kycValidatorContractAddress = '0x5d97A2DD17517379010b6f7FaC1aE7B5c963F91d'; // ropsten
  const kycValidatorContract = useContract(kycValidatorContractAddress, KYC_VALIDATOR_ABI.abi);
  const { setTargetAddress, 
    setHasTargetValidated, 
    targetAddress, 
    isTargetValidated, 
    oracle,
    setOracle,
    jobId,
    setJobId,
    setTxnStatus, 
    setTempData, 
    tempData } = useAppContext();

  const retrieveKYC = async (oracle, jobId, targetAddress) => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setHasTargetValidated("retrieving");
        const txn = await kycValidatorContract.retrieveKYC(oracle, jobId, targetAddress, {
          from: validator
        });
        console.log(txn);
        // await txn.wait(1);
        // const hasKYCData = await kycValidatorContract.hasKYC(targetAddress, {
        //   from: validator,
        // });
        // console.log(hasKYCData);
        // setHasTargetValidated(hasKYCData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  const hasKYC = async (targetAddress) => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setHasTargetValidated("retrieving");
        const hasKYCData = await kycValidatorContract.hasKYC(targetAddress, {
          from: validator,
        });
        setHasTargetValidated(hasKYCData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };


  const getTemp = async () => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        setTempData("retrieving");
        const tempData = await kycValidatorContract.getTemp({
          from: validator,
        });
        setTempData(tempData);
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  return {
    retrieveKYC,
    hasKYC,
    getTemp,
    targetAddress,
    tempData,
    setTargetAddress,
    isTargetValidated,
    oracle,
    setOracle,
    jobId,
    setJobId
  };
};