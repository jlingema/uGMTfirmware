#!/usr/bin/env python
import os
import sys


def encode_error(testbench_name, names):
    error_code = 1 << names.index(testbench_name)
    return error_code


def main():
    error = 0
    testbench_names = ["GMT", "serializer", "deserializer", "SortAndCancel", "ugmt_serdes", "isolation"]
    file_counter = 0
    for root, folders, fnames in os.walk('results'):
        for fname in fnames:
            if fname.endswith(".results"):
                with open(os.path.join(root, fname), 'r') as fobj:
                    file_counter += 1
                    lines = fobj.readlines()
                    res = lines[-1]
                    n_err = int(res.split(":")[1].strip())
                    if n_err != 0:
                        tbname = fname.split("_tb")[0]
                        error += encode_error(tbname, testbench_names)
    if file_counter != len(testbench_names):
        return -1
    return error


if __name__ == "__main__":
    err = main()
    print err
    sys.exit(err)
