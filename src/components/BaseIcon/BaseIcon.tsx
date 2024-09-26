import type { ThemeIcon } from './type';
import React from 'react';
import type { StyleProp, ViewStyle } from 'react-native';
import ArrowLeftIcon from './icons/arrow-left';
import ChevronDownIcon from './icons/chevron-down';
import ChevronLeftIcon from './icons/chevron-left';
import ChevronRightIcon from './icons/chevron-right';
import ChevronUpIcon from './icons/chevron-up';
import CloseIcon from './icons/close';
import BigWarningIcon from './icons/big-warning';
import CheckSuccessIcon from './icons/check-success';

export type Props = {
  /**
   * Name of the icon
   */
  name: ThemeIcon;
  /**
   * Size of the icon.
   */
  size?: number;
  /**
   * Custom icon's text color.
   */
  color?: string;
  /**
   * @optional
   * Style for icon
   */
  style?: StyleProp<ViewStyle>;
};
/**
 *
 * <div class="screenshots">
 *   <figure>
 *     <img class="small" src="screenshots/icon-1.png" />
 *     <figcaption>Default icon</figcaption>
 *   </figure>
 *   <figure>
 *     <img class="small" src="screenshots/icon-2.png" />
 *     <figcaption>Custom icon colors</figcaption>
 *   </figure>
 *   <figure>
 *     <img class="small" src="screenshots/icon-3.png" />
 *     <figcaption>Custom icon sizes</figcaption>
 *   </figure>
 * </div>
 *
 * ## Usage
 * ```js
 */

const BaseIcon = ({ name, color, size, ...rest }: Props) => {
  const DEFAULT_SIZE = 24;

  const iconHeight = size || DEFAULT_SIZE;
  const iconWidth = size || DEFAULT_SIZE;

  const getProps = () => ({
    color: color,
    width: iconWidth,
    height: iconHeight,
    ...rest,
  });

  switch (name) {
    case 'chevron_down':
      //@ts-ignore
      return <ChevronDownIcon {...getProps()} />;
    case 'chevron_left':
      //@ts-ignore
      return <ChevronLeftIcon {...getProps()} />;
    case 'chevron_right':
      //@ts-ignore
      return <ChevronRightIcon {...getProps()} />;
    case 'chevron_up':
      //@ts-ignore
      return <ChevronUpIcon {...getProps()} />;
    case 'close':
      //@ts-ignore
      return <CloseIcon {...getProps()} />;
    case 'arrow_left':
      //@ts-ignore
      return <ArrowLeftIcon {...getProps()} />;
    case 'big_warning':
      //@ts-ignore
      return <BigWarningIcon {...getProps()} />;
    case 'check_success':
      //@ts-ignore
      return <CheckSuccessIcon {...getProps()} />;
    default:
      return null;
  }
};

export default BaseIcon;
