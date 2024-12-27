with source as (
  SELECT
    * from 
    ML.GENERATE_TEXT(
          MODEL `joon-sandbox.alice_one_project.categorize_scheduled_error`,
    ( SELECT  
        CONCAT(
          '[FOR LLM : context] \n',
          'I have a list of questions to help prepare for dbt certification exam.\n',
          'this list is currently unformatted and in a dirty format',
          'as in unformatted text, questions and available choices and answers all in one place, and might',
          'include irrelevant or confusing words to the question context\n',
          'also there might be unverified answers in the list that is untrue to dbt documentation.\n',          
          
          '[FOR LLM : your task] \n',
          
          '1. wrangle the data and format it in a way that is easy to read and understand.\n',
          'parse out what is the question, the available multiple choice answers, and the correct answer and explanation.\n',
          'note that there might be some I forgot to put in the correct answer, in such case please infer from the explanation context.\n'
          'for example, '
          'If the available multiple choice answers are numeric (1, 2, 3, 4, 5), replace them with corresponding alphabetical labels (A = 1, B = 2, etc.). \n',
          'ensure the multiple choice answers (selections) will follow this format with clear readable newline :\n',
          'A) CONTENT CONTENT,\n',
          'B) CONTENT CONTENT\n',
          '.... so on.\n',
          
          '2. truncate irrelevant text that are confusing or irrelevant to the question.\n',
          '3. flag out any questions or answer that is not related to dbt documentation, or even untrue, based on the docs. leave blank if no issue.\n',
          'Refer to the following dbt documentation for verification:\n',
            'https://docs.getdbt.com/reference/references-overview \n',
            'https://docs.getdbt.com/guides \n',
            'and your general knowledge of dbt comamnds and syntax.\n',
          '4. add comma separated tags of some general topics  the question is relevant to to help consume the question easier.\n',
          '5. evaluate the question and answer to determine what level of difficulty the question is: fundamental or advanced. return all lowercase\n',

          '[FOR LLM : output format] \n',
          'structured output as JSON with the following keys.\n',
          'do not wrap your answer in literal json ```json ``` code block syntax. I will parse json myself.\n',
          'the value should be plain text and not nested json object. do include the original newlines if present or added to increase readability.\n',
          '"question"\n',
          '"selections" - what are the multiple choice options.\n',
          '"answer" - the correct choice(s)\n,' ,
          '"explanation" also parsed from input. Do include relevant ref urls if exist\n',
          '"topics" your task instruction at 4. \n',
          '"flags" your task instruction at 3.\n',
          '"difficulty" your task instruction at 5.\n',

          '[FOR LLM : Input:] \n',
          question
        ) AS prompt
  FROM `joon-sandbox.ken_dbt.dbt_cert_raw`),
      STRUCT(
        0.8 AS temperature,
        TRUE AS flatten_json_output,
        8192 as max_output_tokens
      )
    ))

    select *,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.question') AS question,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.selections') AS selections,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.answer') AS answer,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.explanation') AS explanation,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.topics') AS topics,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.flags') AS flags,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.difficulty') AS difficulty
    from source 