import React from 'react';
import styled from 'styled-components';
import ethLogo from '../static/eth-logo.svg';
import compLogo from '../static/comp-logo.svg';
import Text from './Text';
import { colors } from '../theme';

const InputContainer = styled.div`
  border: 1px solid ${colors.green};
  border-radius: 8px;
  padding: 10px;
  input {
    width: 100%;
    border-radius: 8px;
    border: 1px solid ${colors.green};
    padding: 5px;
  }
`;

const EthLogo = styled.img.attrs({
  src: ethLogo,
})`
  height: 36px;
  width: 36px;
`;

const CompLogo = styled.img.attrs({
  src: compLogo,
})`
  height: 36px;
  width: 36px;
`;

const IconWrapper = styled.div``;

const IconMapping = {
  eth: (
    <IconWrapper className="d-flex">
      <EthLogo />
      <Text lineHeight="35px" color={colors.brown}>
        ETH
      </Text>
    </IconWrapper>
  ),
  ctoken: (
    <IconWrapper className="d-flex">
      <CompLogo />
      <Text lineHeight="35px" color={colors.brown}>
        cETH
      </Text>
    </IconWrapper>
  ),
  default: (
    <IconWrapper className="d-flex">
      <CompLogo />
      <Text lineHeight="35px" color={colors.brown}>
        Token
      </Text>
    </IconWrapper>
  ),
};

const JobIdInput = ({ value, setValue, title = 'Job Id' }) => {
  return (
    <InputContainer>
      <div className="d-flex justify-content-between mb-3">
        <Text color={colors.green}>{title}</Text>
      </div>
      <div className="d-flex">
        <input
          type="string"
          value={value}
          onChange={(e) => {
            if (setValue && e.target.value >= 0) {
              setValue(e.target.value);
            }
          }}
        />
      </div>
    </InputContainer>
  );
};

export default JobIdInput;
