# X2C - An XML data to CSV conversion Tool.

## Installing

With ruby installed, simply run:

    gem install x2cs
    
Note, I've only tested this on ruby 1.9.2. I am not sure of compatibility with 1.8. I suggest installing ruby 1.9.2 using RVM.

## Usage

After installing the gem, simply do the following:

    x2cs
    
Enter in the path of an xml file.

Once the file is entered, you will be prompted to enter in the tag name of the entity(ies) you wish to convert. If you have a table containing
contact objects, such as:

    <Contacts>
      <contact>
        <name>John Smith</name>
        <phone>555-123-3333</phone>
        <cell>555-223-2428</cell>
        <email>jsmith@example.com</email>
      </contact>
      <contact>
        <name>Jane Smith</name>
        <phone>555-671-2397</phone>
        <cell>555-343-9851</cell>
        <email>something@xample.org</email>
      </contact>
    </Contacts>
          
Simply type: "contact" (without quotes)