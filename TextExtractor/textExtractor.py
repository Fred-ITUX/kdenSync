import pandas as pd


pd.set_option('display.max_colwidth', None)

#### CSV columns:           Length;Name

#### Paths
path            = "/home/federico/Nextcloud/Python/scripts"
csv_fileName    = f"{path}/TextExtractor/text_extractor.csv"
txt_filename    = f"{path}/TextExtractor/text_out.txt"



df = pd.read_csv(csv_fileName, sep=';', engine='python')
df2 = df.dropna()


def format(row1,row2):

    if row1 == "00:00":
        formattedString     = f'\n\n\n("{str(row1).strip()}","{str(row2).strip()}"),'
    else:
        formattedString     = f'("{str(row1).strip()}","{str(row2).strip()}"),'

    return formattedString



df3 = df2.apply(lambda row: format(row['Length'], row['Name']), axis=1)

#### Write on the txt file
with open(txt_filename, 'w') as txt_file:

    #### Join each formatted row with a newline
    txt_file.write("\n".join(df3))  