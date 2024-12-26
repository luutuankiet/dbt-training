import pandas as pd
import re

def process_questions(input_file, output_file):
    df = pd.read_csv(input_file)
    new_df = pd.DataFrame(columns=['id', 'question', 'answer', 'original_id'])
    
    for index, row in df.iterrows():
        selections = row['selections'] if 'selections' in row else ''
        if isinstance(selections, str):
            # Extract options with letter prefixes A-E
            alpha_pattern = r'([A-E]\).*?)(?=[A-E]\)|$)'
            alpha_options = re.findall(alpha_pattern, selections, re.DOTALL)
            if alpha_options:
                selections = '\n\n'.join(opt.strip() for opt in alpha_options if opt.strip())

        question_text = f"""{row['question']}
================================================
ANSWERS
{selections}
================================================
TOPICS:
{row['topic']}"""

        # Handle answer formatting
        answer = str(row['answer'])
        explanation = row['explanation'] if 'explanation' in row else ''

        answer_text = f"""================================================
{answer}
================================================
{explanation}"""

        new_df.loc[len(new_df)] = {
            'id': index + 1,
            'question': question_text.strip(),
            'answer': answer_text.strip(),
            'original_id': row['id'] if 'id' in row else index + 1
        }
    
    new_df.to_csv(output_file, index=False, lineterminator='\n')

# Usage
process_questions('cert_questions.csv', 'reformatted_cert_questions.csv')
