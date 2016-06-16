'use strict';

import $ from "jquery";
import sticky from "libs/sticky";

// --- sticky main nav ---------------------------------------------------------
$(document).ready( _ => {
    if ($('.js-sticky').length > 0) {
        sticky.init('.js-sticky', {
            highlightEl: '.js-sticky-highlight',
            stopEl: '.js-sticky-stop'
        });

        sticky.viewportMargin = 2;
    }
});
