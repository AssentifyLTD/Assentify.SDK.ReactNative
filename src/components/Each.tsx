import React from 'react';

interface EachProps {
  render: (item: any, index: number) => React.ReactNode;
  of?: any[];
}

const Each: React.FC<EachProps> = ({ render, of }) => {
  return React.Children.toArray(of?.map((item, index) => render(item, index)));
};

export default Each;
