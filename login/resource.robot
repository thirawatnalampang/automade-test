*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${SERVER}            saucedemo.com
${BROWSER}           chrome
${VALID_USER}        standard_user
${VALID_PASSWORD}    secret_sauce
${LOGIN_URL}         https://www.${SERVER}/
${WELCOME_URL}       https://www.${SERVER}/inventory.html
${ERROR_URL}         https://www.${SERVER}/

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Login Page Should Be Open

Login Page Should Be Open
    Title Should Be    Swag Labs
    Wait Until Page Contains Element    id:user-name    10s

Go To Login Page
    Go To    ${LOGIN_URL}
    Login Page Should Be Open

Input Username
    [Arguments]    ${username}
    Input Text    id:user-name    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    id:password    ${password}

Submit Credentials
    Click Button    id:login-button

Welcome Page Should Be Open
    Wait Until Location Contains    /inventory.html    10s
    Location Should Be    ${WELCOME_URL}
    Title Should Be    Swag Labs

Login Should Have Failed
    Wait Until Location Is    ${ERROR_URL}    10s
    Wait Until Page Contains Element    css:[data-test="error"]    10s
