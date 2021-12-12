import React, { createContext, useReducer } from 'react';

const initialContext = {
  targetAddress: '',
  setTargetAddress: () => {},
  oracle: '0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8',
  setOracle: () => {},
  jobId: '7401f318127148a894c00c292e486ffd',
  setJobId: () => {},
  hasTargetValidated: '',
  setHasTargetValidated: () => {},
  tempData: '',
  setTempData: () => {},
  setWalletConnectModal: () => {},
  txnStatus: 'NOT_SUBMITTED',
  setTxnStatus: () => {},
};

const appReducer = (state, { type, payload }) => {
  switch (type) {
    case 'SET_TARGET_ADDRESS':
      return {
        ...state,
        targetAddress: payload,
      };
    case 'SET_ORACLE':
      return {
        ...state,
        oracle: payload,
      };
    case 'SET_JOBID':
      return {
        ...state,
        jobId: payload,
      };
    case 'SET_IS_TARGET_VALIDATED':
      return {
        ...state,
        hasTargetValidated: payload,
      };
    case 'SET_TEMP':
      return {
        ...state,
        tempData: payload,
      };
    case 'SET_WALLET_MODAL':
      return {
        ...state,
        isWalletConnectModalOpen: payload,
      };

    case 'SET_TXN_STATUS':
      return {
        ...state,
        txnStatus: payload,
      };
    default:
      return state;
  }
};

const AppContext = createContext(initialContext);
export const useAppContext = () => React.useContext(AppContext);
export const AppContextProvider = ({ children }) => {
  const [store, dispatch] = useReducer(appReducer, initialContext);

  const contextValue = {
    targetAddress: store.targetAddress,
    setTargetAddress: (targetAddress) => {
      dispatch({ type: 'SET_TARGET_ADDRESS', payload: targetAddress });
    },
    oracle: store.oracle,
    setOracle: (oracle) => {
      dispatch({ type: 'SET_ORACLE', payload: oracle });
    },
    jobId: store.jobId,
    setJobId: (jobId) => {
      dispatch({ type: 'SET_JOBID', payload: jobId });
    },
    hasTargetValidated: store.hasTargetValidated,
    setHasTargetValidated: (hasTargetValidated) => {
      dispatch({ type: 'SET_IS_TARGET_VALIDATED', payload: hasTargetValidated });
    },
    tempData: store.tempData,
    setTempData: (tempData) => {
      dispatch({ type: 'SET_TEMP', payload: tempData });
    },
    isWalletConnectModalOpen: store.isWalletConnectModalOpen,
    setWalletConnectModal: (open) => {
      dispatch({ type: 'SET_WALLET_MODAL', payload: open });
    },
    txnStatus: store.txnStatus,
    setTxnStatus: (status) => {
      dispatch({ type: 'SET_TXN_STATUS', payload: status });
    },
  };

  return <AppContext.Provider value={contextValue}>{children}</AppContext.Provider>;
};
