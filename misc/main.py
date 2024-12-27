import pandas as pd
import re

def process_questions(input_file, output_file):
    df = pd.read_csv(input_file)
    new_df = pd.DataFrame(columns=['id', 'question', 'answer'])
    
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
{row['topics']}"""

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
        }
    
    new_df.to_csv(output_file, index=False, lineterminator='\n')
# Usage
import argparse
parser = argparse.ArgumentParser(description='Process questions from a CSV file.')
parser.add_argument('input_file', help='Path to the input CSV file')
args = parser.parse_args()
input_file = args.input_file
process_questions(input_file, 'reformatted_cert_questions.csv')
