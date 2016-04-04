"""
Takes file with DESeq results as an input and
returns multifasta of correspondent sequences
Multifasta with transcripts is the third positional argument
"""


import sys


def get_first_column(input_file):
    """
    Reads infile with tab-separated values and returns its first column in outlist
    """
    out_list = []
    with open(input_file, 'r') as input_file:
        for line in input_file:
            mod_line = line.strip().split()[0]
            out_list.append(mod_line)
    return out_list


def fasta_filter(fastafile, outfile, list=0):
    """
    :param fastafile: .fasta file to be parsed
    :param list: list of IDs to find in the given .fasta file. Empty by default
    :return: Returns nothing. Prints a file with sequences that went through the filter
    """
    out = open(outfile, 'w')
    with open(fastafile, 'r') as fasta:
        line = next(fasta)
        while True:
            try:
                current_id = ''
                if line.startswith('>'):
                    current_id = line.split(' ')[0][1:]
                    if list and current_id in list:
                        out.write('>' + current_id + '\r\n')
                        while True:
                            line = next(fasta)
                            if line.startswith('>'):
                                break
                            out.write(line.strip() + '\r\n')
                    else:
                        line = next(fasta)
                else:
                    line = next(fasta)
            except StopIteration:
                break
    out.close()


def ids2multifasta(input_file, output_file, transcripts):

    ids = get_first_column(input_file)
    fasta_filter(transcripts, output_file, list=ids)

if __name__ == '__main__':
    infile = sys.argv[1]
    outfile = sys.argv[2]
    transcripts = sys.argv[3]

    print(infile, outfile, transcripts)
    ids2multifasta(infile, outfile, transcripts)
