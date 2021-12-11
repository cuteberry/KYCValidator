import { useContract } from './useContract';
// import C_TOKEN_ABI from '../static/cEthABI';
import MIDDLEMAN_ABI from '../contracts/MiddleMan.json';
import useIsValidNetwork from './useIsValidNetwork';
import { useWeb3React } from '@web3-react/core';
import { useAppContext } from '../AppContext';
import { formatUnits, parseEther } from '@ethersproject/units';
import { useEffect } from 'react';

export const useMiddleMan = () => {
  const { account } = useWeb3React();
  const { isValidNetwork } = useIsValidNetwork();
  const sender = account;
  const receiver = '0x9f0e2042ee058F43aB6b3Ee99287fc61153641aB';
  /* TODO: need an efficient way to handle contract register and set the smart contract as backend contract in register
  const registerContractAddress = '0x75cE2647248Ac610cD1da0023d2774e3eF432bB6'; // ropsten
  const registerContract = useContract(registerContractAddress, CONTRACT_REGISTER_ABI.abi);
  const middlemanContractAddress = '0xF03dFfbc05D470230f93F9c508DC6adbF8d5371E'; // ropsten
  // const middlemanContractAddress = '0xF03dFfbc05D470230f93F9c508DC6adbF8d5371E'; // ropsten
  // const middlemanContractAccountAddress = '0x520A74215410c7832911bb0c7b86c6c353BBd08C'; // ropsten
  
  await registerContract.changeBackend(middlemanContractAddress); // ropsten
  const middlemanContractAddress = await registerContract.backendContract();
  const middlemanContract = useContract(middlemanContractAddress, MIDDLEMAN_ABI.abi);
  */
  const middlemanContractAddress = '0x7629ad9e277046b37C71E720bA0a715311827839'; // ropsten
  //const middlemanContractAccountAddress = '0x520A74215410c7832911bb0c7b86c6c353BBd08C'; // ropsten
  const middlemanContract = useContract(middlemanContractAddress, MIDDLEMAN_ABI.abi);
  
  const { setContractBalance, setSenderBalance, setReceiverBalance, setTxnStatus, contractBalance, senderBalance, receiverBalance } = useAppContext();

  const fetchSenderBalance = async () => {
    const senderBalance = await middlemanContract.balanceOf(sender);
    setSenderBalance(formatUnits(senderBalance, 8));
  };

  const fetchReceiverBalance = async () => {
    const receiverBalance = await middlemanContract.balanceOf(receiver);
    setReceiverBalance(formatUnits(receiverBalance, 8));
  };

  const fetchContractBalance = async () => {
    const contractBalance = await middlemanContract.balanceOf(middlemanContractAddress);
    setContractBalance(formatUnits(contractBalance, 8));
  };

  const withHold = async (amount) => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        await middlemanContract.enroll({
          from: sender
        });
        const txn = await middlemanContract.withhold(receiver, {
          from: sender,
          value: parseEther(amount),
        });
        await txn.wait(1);
        await fetchSenderBalance();
        await fetchReceiverBalance();
        await fetchContractBalance();
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  const refundSender = async () => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        const txn = await middlemanContract.refundSender(receiver, {
          from: sender,
        });
        await txn.wait(1);
        await fetchSenderBalance();
        await fetchReceiverBalance();
        await fetchContractBalance();
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };

  const distributeToReceiver = async () => {
    if (account && isValidNetwork) {
      try {
        setTxnStatus('LOADING');
        const txn = await middlemanContract.distributeToReceiver(receiver, {
          from: sender,
        });
        await txn.wait(1);
        await fetchSenderBalance();
        await fetchReceiverBalance();
        await fetchContractBalance();
        setTxnStatus('COMPLETE');
      } catch (error) {
        console.log(error);
        setTxnStatus('ERROR');
      }
    }
  };
  return {
    fetchSenderBalance,
    fetchReceiverBalance,
    fetchContractBalance,
    withHold,
    refundSender, 
    distributeToReceiver, 
    contractBalance, 
    senderBalance,
    receiverBalance,
  };
};