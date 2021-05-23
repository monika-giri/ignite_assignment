*** Settings ***
Documentation    Suite description
Library     SeleniumLibrary
Library     RequestsLibrary
Library     JSONLibrary
Library     Collections
Library     String
*** Test Cases ***
Verify when user performs search then the list of books shown should be books belonging to the same category and whose search text matches with either title or author name
    [Tags]    DEBUG
    create session       mysession       http://skunkworks.ignitesol.com:8000
    ${response}=    get request        mysession       /books/?search=harry%20great
    ${j}=  to json     ${response.content}
   ${count}=    get value from json    ${j}     count
   ${count}=    get from list     ${count}   0
    Run Keyword if  ${count}>0  Check given string matches with author or title      ${response}
*** Keywords ***
Check given string matches with author or title
   [Arguments]  ${response}
   ${j}=  to json     ${response.content}
   ${count}=    get value from json    ${j}     count
   ${count}=    convert json to string  ${count}
   ${count}=    remove string    ${count}   [     ]
   FOR  ${i}    IN RANGE   ${count}
        ${title}=    get value from json    ${j}         results[${i}].title
        ${title}=    convert json to string   ${title}
        ${author}=    get value from json    ${j}     results[${i}].authors[0].name
        ${author}=    convert json to string   ${author}
        ${title_match}      run keyword and ignore error         should contain  ${title}      harry      ignore_case=True
        ${author_match}      run keyword and ignore error         should contain  ${author}      harry     ignore_case=True
        Exit for loop if    '${title_match}[0]'=='FAIL' and '${author_match}[0]'=='FAIL'
    END
   ${not_found}  run keyword    evaluate    '${title_match}[0]'=='FAIL' and '${author_match}[0]'=='FAIL'
   should be true    ${not_found}==False











