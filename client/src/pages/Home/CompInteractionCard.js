import React, { useEffect, useMemo, useState } from 'react';
import styled from 'styled-components';
import Text from '../../components/Text';
import AddressInput from '../../components/AddressInput';
import JobIdInput from '../../components/JobIdInput';
import OracleInput from '../../components/OracleInput';
import Card from '../../components/Card';
import Button from 'react-bootstrap/Button';
import { colors } from '../../theme';
import { ArrowDown } from 'react-bootstrap-icons';
import Spinner from 'react-bootstrap/Spinner';
import useTransaction from '../../hooks/useTransaction';
import { useKYCValidator } from '../../hooks/useKYCValidator';
import { useAppContext } from '../../AppContext';

const Container = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  padding-top: 10px;
  -webkit-box-align: right;
  align-items: right;
  flex: 1 1 0%;
  overflow: hidden auto;
  z-index: 1;
`;

const CompInteractionCard = () => {
  const [depositAmount, setDepositAmount] = useState(0);
  const { targetAddress,
    setTargetAddress,
    oracle,
    setOracle,
    jobId,
    setJobId,
    retrieveKYC,
    hasKYC, 
    tempData,
    getTemp,
   } = useKYCValidator();
  // const { ethBalance } = useEth();
  const { txnStatus, setTxnStatus } = useTransaction();
  const handleRetrieveKYC = () => retrieveKYC(oracle, jobId, targetAddress);
  const handleHasKYC = () => hasKYC(targetAddress);
  const handleTempData = () => getTemp();
  
  if (txnStatus === 'LOADING') {
    return (
      <Container show>
        <Card style={{ maxWidth: 420, minHeight: 400 }}>
          <Spinner animation="border" role="status" className="m-auto" />
        </Card>
      </Container>
    );
  }

  if (txnStatus === 'COMPLETE') {
    return (
      <Container show>
        <Card style={{ maxWidth: 420, minHeight: 400 }}>
          <Text block center className="mb-5">
            Txn Was successful!
          </Text>
          <Button onClick={() => setTxnStatus('NOT_SUBMITTED')}>Go Back</Button>
        </Card>
      </Container>
    );
  }

  if (txnStatus === 'ERROR') {
    return (
      <Container show>
        <Card style={{ maxWidth: 420, minHeight: 400 }}>
          <Text>Txn ERROR</Text>
          <Button onClick={() => setTxnStatus('NOT_SUBMITTED')}>Go Back</Button>
        </Card>
      </Container>
    );
  }
  return (
    <Container show>
      <Card style={{ maxWidth: 420, minHeight: 400 }}>
        <Text block t2 color={colors.green} className="mb-3">
          KYC Validator
        </Text>
        <OracleInput value="0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8" />
        <JobIdInput  value="7401f318127148a894c00c292e486ffd"/>
        <AddressInput  value={targetAddress} setValue={setTargetAddress}/>
        <Button variant="outline-dark" disabled={targetAddress == ''} className="mt-3" onClick={handleHasKYC}>
          isKYC
        </Button>
        <Button variant="outline-dark" disabled={targetAddress == ''} className="mt-3" onClick={handleRetrieveKYC}>
          Retrieve KYC OffChain
        </Button>
      </Card>
    </Container>
  );
};

export default CompInteractionCard;
