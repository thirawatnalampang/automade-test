*** Settings ***
Library    SeleniumLibrary

Suite Setup     Prepare Cart Suite
Suite Teardown  Close Browser
Test Teardown   Capture Page Screenshot

*** Variables ***
${BASE_URL}          https://www.saucedemo.com/
${USERNAME}          standard_user
${PASSWORD}          secret_sauce

${USER_INPUT}        id=user-name
${PASS_INPUT}        id=password
${LOGIN_BTN}         id=login-button

${CART_ICON}         css:a.shopping_cart_link
${CART_BADGE}        css:span.shopping_cart_badge
${CART_ITEM}         css:div.cart_item
${BTN_ADD}           xpath=//button[normalize-space()='Add to cart']
${BTN_REMOVE}        xpath=//button[normalize-space()='Remove']
${BTN_CHECKOUT}      id=checkout
${BTN_CONTINUE}      id=continue-shopping

*** Test Cases ***

TC-101 View Cart
    [Documentation]    แสดงสินค้าที่ถูกเพิ่มลงในตะกร้า
    Go To    ${BASE_URL}cart.html
    Wait Until Page Contains Element    ${CART_ITEM}    10s
    Page Should Contain Element         ${CART_ITEM}

TC-104 Remove Item
    [Documentation]    ลบสินค้าออกจากตะกร้า 1 รายการ และตรวจสอบจำนวนในตะกร้าลดลง
    Go To    ${BASE_URL}cart.html
    ${before}=    Get Element Count    ${CART_ITEM}
    Click First Remove
    Wait Until Keyword Succeeds    5x    1s    Validate Cart Count Decreased    ${before}

TC-105 Empty Cart
    [Documentation]    ลบสินค้าทั้งหมดให้ตะกร้าว่าง
    Go To    ${BASE_URL}cart.html
    Click All Removes
    Wait Until Page Does Not Contain Element    ${CART_ITEM}    10s
    Page Should Contain Element    ${BTN_CONTINUE}

TC-106 Cart Badge Sync
    [Documentation]    ตรวจสอบตัวเลข badge บนไอคอนตะกร้าให้ตรงกับจำนวนสินค้า
    Go To    ${BASE_URL}inventory.html
    Click First N Adds    2
    Click Element    ${CART_ICON}
    ${in_cart}=    Get Element Count    ${CART_ITEM}
    ${badge}=      Get Text    ${CART_BADGE}
    Should Be Equal As Integers    ${in_cart}    ${badge}

TC-107 Proceed To Checkout
    [Documentation]    ไปหน้า Checkout ได้จากตะกร้า
    Go To    ${BASE_URL}inventory.html
    Click First N Adds    1
    Click Element    ${CART_ICON}
    Wait Until Page Contains Element    ${BTN_CHECKOUT}    10s
    Click Button    ${BTN_CHECKOUT}
    Wait Until Location Contains    /checkout-step-one.html    10s

TC-112 Cart Icon Navigation
    [Documentation]    คลิกไอคอนตะกร้าจาก inventory แล้วต้องไป /cart.html
    Go To    ${BASE_URL}inventory.html
    Wait Until Page Contains Element    ${CART_ICON}    10s
    Click Element    ${CART_ICON}
    Wait Until Location Contains    /cart.html    10s

*** Keywords ***
Prepare Cart Suite
    Open Browser    ${BASE_URL}    chrome
    Wait Until Page Contains Element    ${USER_INPUT}    10s
    Input Text    ${USER_INPUT}    ${USERNAME}
    Input Text    ${PASS_INPUT}    ${PASSWORD}
    Click Button   ${LOGIN_BTN}
    Wait Until Location Contains    /inventory.html    10s
    Click First N Adds    2
    Click Element    ${CART_ICON}
    Wait Until Location Contains    /cart.html    10s

Click All Removes
    ${elements}=    Get WebElements    ${BTN_REMOVE}
    FOR    ${element}    IN    @{elements}
        Click Element    ${element}
    END

Click First Remove
    ${els}=    Get WebElements    ${BTN_REMOVE}
    Click Element    ${els}[0]

Click First N Adds
    [Arguments]    ${n}
    Wait Until Page Contains Element    ${BTN_ADD}    10s
    ${els}=    Get WebElements    ${BTN_ADD}
    ${count}=    Get Length    ${els}
    IF    ${count} < ${n}
        Fail    Not enough items to add: found ${count}, need ${n}
    END
    FOR    ${i}    IN RANGE    0    ${n}
        Click Element    ${els}[${i}]
    END

Validate Cart Count Decreased
    [Arguments]    ${before}
    ${after}=    Get Element Count    ${CART_ITEM}
    Should Be Equal As Integers    ${before - 1}    ${after}