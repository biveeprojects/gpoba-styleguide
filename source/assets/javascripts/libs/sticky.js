// Sticky module
// -> make an element "sticky" (fixed) depending on scroll position
//
// by Bivee
// bivee.co, github.com/biveeco
// -----------------------------------------------------------------------------
'use strict';

import $ from 'jquery';

// -> PUBLIC (exported) API
const api = {

    // --- base settings and their defaults ------------------------------------
    // -> these can be changed globally and should persist across multiple init() calls
    fixedClass     : "is-fixed",
    currentClass   : "is-active",
    bottomClass    : "at-bottom",
    viewportMargin : 4,

    // --- main function -------------------------------------------------------
    // @param STRING el: a selector for element(s) we want to make sticky
    // @param STRING parentEl (optional): a parent element in which the element is sticky
    // @param STRING highlightEl (optional): an element you'd like the highlight on scroll. uses attribute value.
    // @param STRING stopEl (optional): element which "stops" the sticky behavior
    init : function(el, options = {}) {

        // defaults for options parameter
        const parentEl            = options.parentEl || window,
              stopEl              = options.stopEl || false,
              highlightEl         = options.highlightEl || false,
              highlightTargetAttr = options.highlightTargetAttr || "href";

              // debugger;

        $(el).each(function() {
            let elH          = $(el).outerHeight(), // height of the sticky element
                parentH      = $(parentEl).height(), // height of the parent element
                $highlightEl = highlightEl ? $(highlightEl) : false, // store a reference to jquery object
                stopPos      = $(stopEl).length > 0 ? $(stopEl).offset().top : false, // vertical pos of the "stop" element, if there is one
                yPosInit     = $(el).offset().top; // target element's offset (distance to top)

            // call the toggle function to set correct initial state
            toggleSticky(el, elH, yPosInit, stopPos);

            // now do things when we scroll
            $(parentEl).scroll(function() {
                toggleSticky(el, {
                    elH: elH,
                    offset: yPosInit,
                    stopPos: stopPos
                });

                // highlight the current nav item based on scroll position
                if ($highlightEl) {
                    toggleHighlight($highlightEl, highlightTargetAttr);
                }
            });

            // reset the target element's offset & height when the window resizes
            $(parentEl).resize(function() {
                toggleSticky(el, {
                    elH: $(el).outerHeight(),
                    offset: $(el).offset().top,
                    stopPos: stopPos
                });
            });
        });
    }
}

// --- Toggle stickiness -------------------------------------------------------
// -> Decide whether the element should be sticky or not
// -> PRIVATE
// @param STRING el: selector for the element we want to make sticky
// @param NUMBER elH (optional): height of the sticky element
// @param NUMBER offset (optional): the element's distance to the top of the page
// @param NUMBER stopPos (optional): the vertical position of the 'stop' element
function toggleSticky(el, options = {}) {

    // optional params and their defaults
    // -> pass these values in b/c recalculating them is slow
    const elH       = options.elH || $(el).outerHeight(),
          offset    = options.offset || $(el).offset().top,
          stopPos   = options.stopPos || false;

    let scrollPos = $(window).scrollTop(),
        scrollBottom = scrollPos + elH;

    // if we've scrolled up to or past the "sticky" point...
    if ((offset <= scrollPos)) {
        // add the 'fixed' class to the element
        $(el).addClass(api.fixedClass);

        // also remove the "bottom" class if we care about that
        if (stopPos && scrollBottom <= stopPos) {
            $(el).removeClass(api.bottomClass);
        }
            console.log("sticky");

    // otherwise, if we're scrolled above or below the sticky point...
    } else {
        // remove the fixed class
        $(el).removeClass(api.fixedClass);
        console.log("not sticky");

        // if we care about a bottom point, check to see if we're below it
        if (stopPos && scrollBottom >= stopPos) {
            $(el).addClass(api.bottomClass);
            console.log("at bottom");
        }
    }
}

// --- Toggle highlights -------------------------------------------------------
// -> add a 'highlight' class to an anchor element when we scroll past its href target
// -> PRIVATE
function toggleHighlight($el, targetAttr = "href") {
    $el.each(function() {
        const $target = $($(this).attr(targetAttr));

        // see if the target element (section, usually) is visible in the window
        if (checkVisible($target)) {
            // if so, add the "active" class to the relevant child
            $(this).addClass(api.currentClass);
            // console.log($(this).attr('href') + " is visible");
        } else {
            // otherwise, remove it
            $(this).removeClass(api.currentClass);
        };
    });
}

// --- Check if the element is visible on-screen -------------------------------
// -> http://bit.ly/1Tz9Unm
// -> PRIVATE
function checkVisible(el) {
    const viewportMargin = ($(window).height()/api.viewportMargin), // Viewport Height
        scrollPos = $(window).scrollTop(), // Scroll Top
        yPos = $(el).offset().top,
        elH = $(el).outerHeight();

    return ((yPos < (viewportMargin + scrollPos)) && (yPos > (scrollPos + viewportMargin - elH)));
}

export default api;
