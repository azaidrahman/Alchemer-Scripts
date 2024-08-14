import pandas as pd
import sys

arguments = sys.argv
filename = arguments[1]

df = pd.read_excel(filename)

vendors = df["BCID"].unique()
valid_vendors = [
    "paneland",
    "cint",
    "pspec",
    "gvr",
    "offline",
    "philomath",
    "var",
    "mirats",
]
if "EXPORT" in filename:
    sub = "EXPORT"
    newfile = filename.replace(sub, "")
else:
    newfile = filename

id = {}
IR = {}

for vendor in vendors:
    # if vendor in valid_vendors:
    id[vendor] = df.loc[(df["Status"] == "Complete") & (df["BCID"] == vendor), ["BRID"]]
    id_count = int(id[vendor].count())
    print(f"{vendor}: {id_count}")
    id[vendor]["Response ID"] = df.loc[
        (df["Status"] == "Complete") & (df["BCID"] == vendor), ["Response ID"]
    ]

    counts = df.loc[df["BCID"] == vendor, ["Status"]].value_counts()
    counts["Incidence Rate"] = "{:.1%}".format(
        int(counts["Complete"])
        / (int(counts["Complete"]) + int(counts["Disqualified"]))
    )

    IR[vendor] = counts
    id[vendor].to_excel(f"{vendor}  N={id_count} FINAL ID {newfile}", index=False)

IR = pd.DataFrame.from_dict(IR)

IR.to_csv(f"incidence {newfile_text}.csv")
# IR.to_excel(f'{newfile}_incidence rate',index=False)
