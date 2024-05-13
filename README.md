### Process Line List data for Eastern DRC bacterial meningitis surveillance

This code processes a line list data in a file called `LineList.xlsx`, provided
by INRB Goma lab. It cleans up the column names, it assigns correct data types
to numeric and date columns and filters out samples that failed either one
of the two PCR reactions used in the Sansure kits. Finally it selects samples
with a Ct value less than 30 and does some plotting with this data.

### Map samples to health zones.

The geospatial resources are in the `geodata/` directory and are drawn from
the HDX [DRC Zones de santé](https://data.humdata.org/dataset/zones-de-sante-rdc?).
The use of this data is still a work in progress but also consider
[Aires de santé](https://data.humdata.org/dataset/drc-health-data) and
other datasets from [HDX DRC Resources](https://data.humdata.org/dataset/?groups=cod&q=&sort=last_modified%20desc&ext_page_size=25).
