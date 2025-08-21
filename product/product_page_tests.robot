*** Settings ***
Library    SeleniumLibrary

Suite Setup     Login To SauceDemo
Suite Teardown  Close Browser
Test Teardown   Capture Page Screenshot

*** Variables ***
${BASE_URL}          https://www.saucedemo.com/
${USERNAME}          standard_user
${PASSWORD}          secret_sauce

${USER_INPUT}        id=user-name
${PASS_INPUT}        id=password
${LOGIN_BTN}         id=login-button

${BTN_ADD}           xpath=//button[normalize-space()='Add to cart']
${BTN_REMOVE}        xpath=//button[normalize-space()='Remove']
${FILTER_SELECT}     css:select.product_sort_container
${CART_ICON}         css:a.shopping_cart_link

*** Test Cases ***

TC-007 Add And Remove Items
    [Documentation]    Adding all available products to the cart and then removing them
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${BTN_ADD}    10s
    Click Elements    ${BTN_ADD}
    Wait Until Page Contains Element    ${BTN_REMOVE}    10s
    Click Elements    ${BTN_REMOVE}
    Page Should Not Contain Element     ${BTN_REMOVE}

TC-008 Sort Items A To Z
    [Documentation]    Verify sorting from A to Z
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${FILTER_SELECT}    10s
    Select From List By Label    ${FILTER_SELECT}    Name (A to Z)
    Page Should Contain    Sauce Labs Backpack

TC-009 Sort Items Z To A
    [Documentation]    Verify sorting from Z to A
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${FILTER_SELECT}    10s
    Select From List By Label    ${FILTER_SELECT}    Name (Z to A)
    Page Should Contain    Test.allTheThings() T-Shirt (Red)

TC-010 Sort Items Low To High
    [Documentation]    Verify sorting price low to high
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${FILTER_SELECT}    10s
    Select From List By Label    ${FILTER_SELECT}    Price (low to high)
    Page Should Contain    $7.99

TC-011 Sort Items High To Low
    [Documentation]    Verify sorting price high to low
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${FILTER_SELECT}    10s
    Select From List By Label    ${FILTER_SELECT}    Price (high to low)
    Page Should Contain    $49.99

TC-012 Cart Icon Navigation
    [Documentation]    Clicking cart icon should navigate to cart page
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${CART_ICON}    10s
    Click Element    ${CART_ICON}
    Location Should Contain    /cart.html

*** Keywords ***
Login To SauceDemo
    Open Browser    ${BASE_URL}    chrome
    Wait Until Page Contains Element    ${USER_INPUT}    10s
    Input Text    ${USER_INPUT}    ${USERNAME}
    Input Text    ${PASS_INPUT}    ${PASSWORD}
    Click Button   ${LOGIN_BTN}
    Wait Until Location Contains    /inventory.html    10s

*** Keywords ***
Click Elements
    [Arguments]    ${locator}
    ${els}=    Get WebElements    ${locator}
    FOR    ${el}    IN    @{els}
        Scroll Element Into View    ${el}
        Click Element    ${el}
    END