window.Parsley
  .addValidator('biggerOrEqualto', {
    // string | number | integer | date | regexp | boolean
    requirementType: 'string',

    // validateString | validateDate | validateMultiple
    validateNumber (value, requirement) {
      requirement = parseFloat($(requirement).val());
      return value >= requirement;
    },

    messages: {
      en: "This value should be bigger or equal to %s.",
      es: "Este valor debe ser mayor o igual que %s."
     }
  });

window.Parsley
  .addValidator('lowerOrEqualto', {
    // string | number | integer | date | regexp | boolean
    requirementType: 'string',

    // validateString | validateDate | validateMultiple
    validateNumber (value, requirement) {
      requirement = parseFloat($(requirement).val());
      return value <= requirement;
    },

    messages: {
      en: "This value should be lower or equal to %s.",
      es: "Este valor debe ser menor o igual que %s."
     }
  });
