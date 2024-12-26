with source as (
  SELECT
    * from 
    ML.GENERATE_TEXT(
          MODEL `joon-sandbox.alice_one_project.categorize_scheduled_error`,
    ( SELECT  
        CONCAT(
          'Analyze this dbt certification question and return structured output as JSON with keys: ',
          '"question" - mapped to question column,' ,
          '"selections"- mapped to selections column,',
          '"answer" - mapped to answer column,' ,
          '"explanation": parsed from answer column',
          '"topics" mapped to topics column',
          'do not wrap your answer in literal json ```json ``` code block syntax. I will parse json myself.',
          'Do note that my data is unclean and there is no fixed number of selections.',
          'Please normalize the answer options to alphabetical labels (A, B, C, D, E). ',
          'If the answers are numeric (1, 2, 3, 4, 5), replace them with corresponding alphabetical labels (A = 1, B = 2, etc.). ',
          'ensure that each selection and answers will follow this format with clear readable newline :',
          'A) CONTENT CONTENT,',
          'B) CONTENT CONTENT',
          '.... so on.',
          'Input: ',
          'question:', question, 
          'selections: ', selections,
          'answer: ',answer,
          'explanation', answer,
          'topics:', topic
        ) AS prompt
  FROM `ken_dbt.dbt_cert`),
      STRUCT(
        0.8 AS temperature,
        TRUE AS flatten_json_output,
        8192 as max_output_tokens
      )
    ))

    select
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.question') AS parsed_question,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.selections') AS parsed_selections,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.answer') AS parsed_answer,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.explanation') AS parsed_explanation,
  JSON_EXTRACT_SCALAR(ml_generate_text_llm_result, '$.topics') AS parsed_topics
    from source 