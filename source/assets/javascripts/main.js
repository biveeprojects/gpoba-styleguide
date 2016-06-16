'use strict';

import $ from "jquery";
import sticky from "libs/sticky";

$(document).ready( _ => {
    if ($('.js-sticky').length > 0) {
        sticky.init('.js-sticky', {
            highlightEl: '.js-sticky-highlight',
            stopEl: '.js-sticky-stop'
        });

        sticky.viewportMargin = 2;
    }
});
