// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Hands} from '../Hands.sol';

library BodyHoodie {
    function getBody(Hands.HandsVariants handsVariant) public pure returns (string memory) {
        if (handsVariant == Hands.HandsVariants.HANDSDOWN) {
            return
                '<path class="handsColor" d="m55.9 209.2 13.9 6.7-4.5 17.8 2 12-3 5.8-8.4 1.4H44.4l-9.4-7.2 1.5-13.4 10.4-6.8 9-16.3ZM154.2 210.2l-14 6.7 4.5 17.8-2 12 3 4.8 8.5 2.4h11.4l9.4-7.2-1.5-13.5-10.4-6.7-9-16.3Z"/><path class="bStr1" stroke-width="4" d="M55.9 209.4c-2.6 4.3-5.1 8.6-7.7 13.5a16.2 16.2 0 0 1-6 5.8 15 15 0 0 0-7 10.1 13.6 13.6 0 0 0 7.4 14.1c4.2 2 9.5 1.4 13.3-1.2"/><path class="bStr1" stroke-width="2" d="M57.8 247.6a11.2 11.2 0 0 1-5 4.8M152.2 247.6c1.5 2.4 2.4 3.4 5 4.8"/><path class="bStr1" stroke-width="4" d="M56 251.7a8 8 0 0 0 7.9 0 7.1 7.1 0 0 0 3.7-6.5M154 209.4c2.5 4.3 5 8.6 7.6 13.5 1.3 2.5 3.7 4.3 6.1 5.8a15 15 0 0 1 7 10.1c.9 5.6-2.2 11.6-7.4 14.1-4.2 2-9.6 1.4-13.3-1.2M153.8 251.7a8 8 0 0 1-7.8 0c-2.4-1.4-3.9-3.3-3.8-6"/><path class="bodyColor1" d="m68.8 187.6 20.5-5.6h29.5l20.5 5.6 10 8.2 5 7 5.5 11.8 3.7 4.2 2.9 4.7-7.7 6.2-13.3 3.8v8l-5 5.6-8.8 4.2-11.9 4.6-12.9 1.6H97L84.2 254l-13.6-7-6.5-5.7V233l-14.2-3.6-6.6-6.2 5.5-7.6 5.3-9.4 8.5-13.3 6.2-5.3Z"/><path class="bStr2" stroke-width="3" d="m64.8 233.5 6.7-24.6"/><path class="bStr2" stroke-width="4" d="M69.4 187.8c-5.6 1.8-9.7 6.9-12.7 12.2-3 5.3-5 11.1-8.5 16.1a10.4 10.4 0 0 0-4.9 7.3c5.3 5.7 13 9.1 21.1 9.2-.7 3-1.5 6 0 8.6 1.5 2.6 4 4.4 6.5 5.9a67.4 67.4 0 0 0 34 10.4"/><path class="bStr2" stroke-width="4" d="M140.3 187.8c5.6 1.8 9.7 6.9 12.7 12.2 3 5.3 5 11.1 8.5 16.1 2.6 1.6 4.4 4.3 5 7.3-5.3 5.7-13.1 9.1-21.2 9.2.7 3 1.5 6 0 8.6-1.5 2.6-4 4.4-6.5 5.9a66.8 66.8 0 0 1-34 10.4"/><path class="bStr2" stroke-width="3" d="m145 233.5-6.8-24.6"/><path class="bStr3" d="M52.3 219.5s2.3 2 4 3c1.8 1 5.5 2 5.5 2"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M93.3 182.5h-6.5s-2.7 9.9-4.4 23.3l-2 16.4h.5l-.2 2.1a2 2 0 0 0 1.7 2.2l1.5.2a2 2 0 0 0 2.2-1.8l.2-2 .5.1 2-17.2a136 136 0 0 1 4.5-23.3Z"/><path class="bStr3" d="m80.3 221 6.5.5"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M116.3 182.5h6.5s2.8 9.9 4.4 23.3l2.1 16.4h-.5l.2 2.1a2 2 0 0 1-1.8 2.2l-1.5.2a2 2 0 0 1-2.2-1.8l-.2-2-.5.1-2-17.2c-1.8-15.2-4.5-23.3-4.5-23.3Z"/><path class="bStr3" d="m129.3 221-6.5.5M156.8 219.5s-2.3 2-4 3c-1.8 1-5.5 2-5.5 2"/><path fill="#fff" fill-opacity=".5" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1 1.4 2.2 2.6 5.2 3.5 8 .4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5M105.4 235.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8c-.5 1.5.1 3 1.4 3.7a40 40 0 0 0 19.5 4.5"/><path class="bStr3" d="M87.7 245.4s.4-3.2 1.1-5.1c.7-2.1 2.4-5.1 2.4-5.1M123 245.4s-.5-3.2-1.2-5.1c-.7-2.1-2.4-5.1-2.4-5.1"/><path class="bStr2" stroke-width="3" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1 1.4 2.2 2.6 5.2 3.5 8 .4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5M105.4 235.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8c-.5 1.5.1 3 1.4 3.7a40 40 0 0 0 19.5 4.5"/></svg>';
        } else if (handsVariant == Hands.HandsVariants.PEACEDOUBLE) {
            return
                '<path class="bodyColor1" d="m68.8 187.6 20.5-5.6h29.5l20.5 5.6 10 8.2 5 7 5.5 11.8 5 4-1.3 3.8-7 6h-11.8l.7 13-5 5.7-8.8 4.2-11.9 4.6-12.9 1.6H97L84.2 254l-13.6-7-6.5-5.7 1.2-13.1h-12l-8-5.2 3.5-7.5 5.3-9.4 8.5-13.3 6.2-5.3Z"/><path class="bStr2" stroke-width="3" d="m64.8 233.5 6.7-24.6"/><path class="bStr2" stroke-width="4" d="M48.2 216.1c3.4-5 5.6-10.8 8.5-16.1 3-5.3 7.1-10.4 12.7-12.2 0 0 4.5-6.3 35.5-6.3s35.4 6.3 35.4 6.3c5.6 1.8 9.7 6.9 12.7 12.2 3 5.3 5 11.1 8.5 16.1m-95 9.3c-.8 3-3.6 13.2-2 15.8 1.4 2.6 4 4.4 6.4 5.9a67.4 67.4 0 0 0 34 10.4c11.7 0 23.8-4.2 34-10.4a18 18 0 0 0 6.4-5.9c1.5-2.6-1.4-12.8-2-15.8"/><path class="bStr2" stroke-width="3" d="m145 233.5-6.8-24.6"/><path class="bStr3" d="M52.3 219.5s2.3 2 4 3c1.8 1 5.5 2 5.5 2"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M93.3 182.5h-6.5s-2.7 9.9-4.4 23.3l-2 16.4h.5l-.2 2.1a2 2 0 0 0 1.7 2.2l1.5.2a2 2 0 0 0 2.2-1.8l.2-2 .5.1 2-17.2a136 136 0 0 1 4.5-23.3Z"/><path class="bStr3" d="m80.3 221 6.5.5"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M116.3 182.5h6.5s2.8 9.9 4.4 23.3l2.1 16.4h-.5l.2 2.1a2 2 0 0 1-1.8 2.2l-1.5.2a2 2 0 0 1-2.2-1.8l-.2-2-.5.1-2-17.2a129.5 129.5 0 0 0-4.5-23.3Z"/><path class="bStr3" d="m129.3 221-6.5.5m34-2s-2.3 2-4 3c-1.8 1-5.5 2-5.5 2"/><path fill="#fff" fill-opacity=".5" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1a42 42 0 0 1 3.5 8c.4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/><path class="bStr2" stroke-width="3" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1a42 42 0 0 1 3.5 8c.4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/><path class="bStr3" d="M87.7 245.4s.4-3.2 1.1-5.1c.7-2.1 2.4-5.1 2.4-5.1m31.8 10.2s-.5-3.2-1.2-5.1c-.7-2.1-2.4-5.1-2.4-5.1"/><path class="bStr2" stroke-width="3" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1a42 42 0 0 1 3.5 8c.4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/></svg>';
        } else if (handsVariant == Hands.HandsVariants.PEACESINGLE) {
            return
                '<path class="handsColor" d="m55.9 209.2 13.9 6.7-4.5 17.8 2 12-3 5.8-8.4 1.4H44.4l-9.4-7.2 1.5-13.4 10.4-6.8 9-16.3Z"/><path class="bStr1" stroke-width="4" d="M55.9 209.4c-2.6 4.3-5.1 8.6-7.7 13.5a16.2 16.2 0 0 1-6 5.8 15 15 0 0 0-7 10.1 13.6 13.6 0 0 0 7.4 14.1c4.2 2 9.5 1.4 13.3-1.2"/><path class="bStr1" stroke-width="2" d="M57.8 247.6a11.2 11.2 0 0 1-5 4.8"/><path class="bStr1" stroke-width="4" d="M56 251.7a8 8 0 0 0 7.9 0 7.1 7.1 0 0 0 3.7-6.5"/><path class="bodyColor1" d="m68.8 187.6 20.5-5.6h29.5l20.5 5.6 10 8.2 5 7 5.5 11.8 5 4-1.3 3.8-7 6h-11.8l.7 13-5 5.7-8.8 4.2-11.9 4.6-12.9 1.6H97L84.2 254l-13.6-7-6.5-5.7V233l-14.2-3.6-6.6-6.2 5.5-7.6 5.3-9.4 8.5-13.3 6.2-5.3Z"/><path class="bStr2" stroke-width="3" d="m64.8 233.5 6.7-24.6"/><path class="bStr2" stroke-width="4" d="M161.5 216.1c-3.4-5-5.5-10.8-8.5-16.1-3-5.3-7-10.4-12.7-12.2 0 0-4.5-6.3-35.4-6.3-31 0-35.5 6.3-35.5 6.3-5.6 1.8-9.7 6.9-12.7 12.2-3 5.3-5 11.1-8.5 16.1a10.4 10.4 0 0 0-4.9 7.3c5.3 5.7 13 9.1 21.1 9.2-.7 3-1.5 6 0 8.6 1.5 2.6 4 4.4 6.5 5.9a67.4 67.4 0 0 0 34 10.4c11.7 0 23.8-4.2 34-10.4a18 18 0 0 0 6.4-5.9c1.5-2.6-1.4-12.8-2-15.8"/><path class="bStr2" stroke-width="3" d="m145 233.5-6.8-24.6"/><path class="bStr3" d="M52.3 219.5s2.3 2 4 3c1.8 1 5.5 2 5.5 2"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M93.3 182.5h-6.5s-2.7 9.9-4.4 23.3l-2 16.4h.5l-.2 2.1a2 2 0 0 0 1.7 2.2l1.5.2a2 2 0 0 0 2.2-1.8l.2-2 .5.1 2-17.2a136 136 0 0 1 4.5-23.3Z"/><path class="bStr3" d="m80.3 221 6.5.5"/><path fill="#fff" fill-opacity=".5" class="bStr2" stroke-width="3" d="M116.3 182.5h6.5s2.8 9.9 4.4 23.3l2.1 16.4h-.5l.2 2.1a2 2 0 0 1-1.8 2.2l-1.5.2a2 2 0 0 1-2.2-1.8l-.2-2-.5.1-2-17.2a129.5 129.5 0 0 0-4.5-23.3Z"/><path class="bStr3" d="m129.3 221-6.5.5m34-2s-2.3 2-4 3c-1.8 1-5.5 2-5.5 2"/><path fill="#fff" fill-opacity=".5" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1 1.4 2.2 2.6 5.2 3.5 8 .4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/><path class="bStr2" stroke-width="3" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1 1.4 2.2 2.6 5.2 3.5 8 .4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/><path class="bStr3" d="M87.7 245.4s.4-3.2 1.1-5.1c.7-2.1 2.4-5.1 2.4-5.1m31.8 10.2s-.5-3.2-1.2-5.1c-.7-2.1-2.4-5.1-2.4-5.1"/><path class="bStr2" stroke-width="3" d="M105.4 235.7a68 68 0 0 0 14.6-2.5c1-.2 2.1.1 2.7 1 1.4 2.2 2.6 5.2 3.5 8 .4 1.5-.2 3-1.5 3.7a39.7 39.7 0 0 1-19.3 4.5m0-14.7a69 69 0 0 1-14.7-2.5c-1-.2-2.2.1-2.8 1a36.1 36.1 0 0 0-3.4 8 3 3 0 0 0 1.4 3.7 40 40 0 0 0 19.5 4.5"/></svg>';
        } else {
            revert(); // Avoid warnings.
        }
    }
}