import { useMemo } from 'react';
import { useWeb3React } from '@web3-react/core';

const supportedCompNetworks = [1, 2, 3, 4, 42, 1637976866526];

function useIsValidNetwork() {
  const { chainId } = useWeb3React();

  const isValidCompNetwork = useMemo(() => {
    return supportedCompNetworks.includes(chainId);
  }, [chainId]);

  return {
    isValidNetwork: isValidCompNetwork,
  };
}

export default useIsValidNetwork;
