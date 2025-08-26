# Crash Driver Report

For several years, NIEM has used the CrashDriverInfo message type to test and describe various features of the NIEM technical architecture.  These messages report various aspects of a motor vehicle crash, describing:

* date and location
* vehicles involved
* drivers of involved vehicles
* other people involved
* any injuries
* any criminal charges
* relationships among people involved

The example messages are intended to be simple, compact illustrations of architecture features as they appear within NIEM messages. They are not intended to be especially plausible in the real world.

## What's new in version 1.3

Version 1.3 is designed to demonstrate all features of the NIEM 6.0 technical architecture.  New features include:

* *References instead of role types:*  In previous versions of NIEM, you would see special `RoleOf` objects, like this:

  ```
  <nc:Person structures:id="P01">
    <nc:PersonName>
      <nc:PersonFullName>Peter Wimsey</nc:PersonFullName>
    </nc:PersonName>
  </nc:Person>
  <j:CrashPerson>
    <nc:RoleOfPerson structures:ref="P01"/>
    <j:CrashPersonInjury>
      <nc:InjuryDescriptionText>Broken Arm</nc:InjuryDescriptionText>
      <j:InjurySeverityCode>3</j:InjurySeverityCode>
    </j:CrashPersonInjury
  </j:CrashPerson>
  ```

  The `nc:RoleOfPerson` element tells us that the person named Peter Wimsey has the role of a CrashPerson in this message.  (See [NDR 5.0 §10.2, Role types and roles](https://reference.niem.gov/niem/specification/naming-and-design-rules/5.0/niem-ndr-5.0.html#section_10.2.2).)  

  NIEM6 does not have role types; instead, it uses `structures:uri` to indicate elements that represent the same object.  In NIEM 6, you would see this:

  ```
  <nc:Person structures:uri="#P01">
    <nc:PersonName>
      <nc:PersonFullName>Peter Wimsey</nc:PersonFullName>
    </nc:PersonName>
  </nc:Person>
  <j:CrashPerson structures:uri="#P01">
    <j:CrashPersonInjury>
      <nc:InjuryDescriptionText>Broken Arm</nc:InjuryDescriptionText>
      <j:InjurySeverityCode>3</j:InjurySeverityCode>
    </j:CrashPersonInjury
  </j:CrashPerson>
  ```

  The two elements, `nc:Person` and `j:CrashPerson`, are providing values for a single person object. (See [NDR 6.0 §5.4, Roles](https://niemopen.github.io/niem-naming-design-rules/ndr-v6.0-ps01.html#54-roles).)

* *Ordered properties:*  By default, the order of a repeated element is not significant.  NIEM 6 introduces a new *appinfo* property for those times when it is.  For example, the order of a person's middle names is significant.

  ```
  <xs:element name="PersonMiddleName" type="nc:PersonNameTextType" appinfo:orderedPropertyIndicator="true">
    <xs:annotation>
      <xs:documentation>A middle name of a person.</xs:documentation>
    </xs:annotation>
  </xs:element>
  ```

  (See [NDR 6.0 §14.2.8, Ordered properties](https://niemopen.github.io/niem-naming-design-rules/ndr-v6.0-ps01.html#1428-ordered-properties).)

* *Relationship properties:*  The value of a property usually provides information about its parent object.  Sometimes this is not what is wanted.  For example:

  ```
  <nc:Person>
    <nc:PersonName>
      <nc:PersonFullName>Superman</nc:PersonFullName>
    </nc:PersonName> 
    <nc:PersonName my:isSecret="true"> 
      <nc:PersonFullName>Clark Kent</nc:PersonFullName> 
    </nc:PersonName> 
  </nc:Person>   
  ```

  We do not want to assert that the name "Clark Kent" is secret.  That name is published every day as a byline in the *Daily Planet*!  The real secret is the *relationship* between that name and the person object that also has the name "Superman".  NIEM 6 introduces new appinfo for this sort of property.  (See [NDR 6.0 §5.3, Relationship properties](https://niemopen.github.io/niem-naming-design-rules/ndr-v6.0-ps01.html#53-relationship-properties).)

* *Ordinary objects for metadata:*  Earlier NIEM versions used `structures:metadata` and special metadata types.  Metadata objects in NIEM 6 are just like any other object, and can be applied as augmentations by the message designer.

* *Attribute augmentations:*  Earlier NIEM versions had no way to augment a type with an attribute property, so if you wanted something like `<nc:PersonName my:isSecret="true"/>`, you were out of luck.

* *Augmenting simple content with an object:*  Also not possible in previous versions.  NIEM 6 introduces *reference attributes* to make this possible.  (See [NDR 6 §14.2.10, Reference attributes](https://niemopen.github.io/niem-naming-design-rules/ndr-v6.0-ps01.html#14210-reference-attributes).)

* *Reference constraints:*  In previous versions, every element could be the target of a reference.  So in theory, message implementers were supposed to check for things like this:

  ```
  <nc:Person>
    <nc:PersonJobTitleText structures:id="t01">Supervisor</nc:PersonJobTitleText>
  </nc:Person>
  <nc:Person>
    <nc:PersonJobTitleText structures:ref="t01" xsi:nil="true"/>
  </nc:Person>
  ```

  In NIEM 6, objects must appear inline by default.  If you want references, you must ask for them in the message model.  For example, if you want messages with `<nc:Person structures:uri="#P01"/>, you must say so with appinfo in the model, like this:

  ```
  <xs:complexType name="PersonType" appinfo:referenceCode="ANY">
    <xs:annotation>
      <xs:documentation>A data type for a human being.</xs:documentation>
    </xs:annotation>
    <xs:complexContent> ...
  ```

  (See [NDR 6.0 §14.2.3, Objects and object identifiers](https://niemopen.github.io/niem-naming-design-rules/ndr-v6.0-ps01.html#1423-objects-and-object-identifiers).)

* *Simplified message schemas:*  

## Contents

* *model.xsd:*  An XML schema document pile representing the NIEM model for the CrashDriverInfo message type
* *model.cmf:* The CMF representation of the same NIEM model
* *model.ttl:*  RDF entailed by the NIEM model, using OWL and RDFS.  *Experimental*
* *message.xsd:* A simplified message schema for validating CrashDriverInfo messages in XML format
* *message.json:* A JSON Schema file for validating CrashDriverInfo messages in JSON format
* *examples:* Sample messages in XML and JSON format; *msg1.xml* is equivalent to *msg1.json*, etc.
  * *msg1:*  Shows object references. ordered properties, augmentations with and without an augmentation element, and ordinary metadata objects
  * *msg2:*  More person objects, more associations
  * *msg3:*  Reference attribute for augmenting `exch:PersonFictionalGenreCode` (simple content) with privacy metadata.  Also shows `exch:ReferenceObjects` pattern for objects that appear only as references, anddo not modify their parent.
  * *msg4:*  Adapter for location elements in external GML namespace
  * *msg5:*  Relationship property `priv:privacyRelationCode` for Peter Wimsey's secret alias (Roger Carstairs)

## Tool demonstration

This message specification can be used to demonstrate two open-source developer tools provided by NIEMOpen:

* CMFTool converts model representations between CMF and XSD, and generates message schemas to validate XML and JSON messages.
* NIEMTran converts messages beteween XML and JSON formats

`make clean` removes everything except the XSD model representation and the XML message examples.

`make all` uses CMFTool and NIEMTran to generate everything else.  In a tool demonstration, you can do the same thing, one command at a time.



