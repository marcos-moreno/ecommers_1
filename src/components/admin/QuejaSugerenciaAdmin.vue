      
<template>

      <v-container style="justify:left;width: 80%">

  <v-form
    ref="form"
    v-model="valid"
    lazy-validation
  >
    <v-text-field
      v-model="name"
      :rules="nameRules"
      label="Nombre Completo"
      required
    ></v-text-field>

    <v-text-field
      v-model="email"
      :rules="emailRules"
      label="Correo Electrónico"
      required
    ></v-text-field>

    <v-select
      v-model="select"
      :items="items"
      :rules="[v => !!v || 'Tema es obligatorio']"
      label="Tema"
      required
      disabled
    ></v-select>

    <v-file-input
        accept="image/*"
        label="Adjuntar Archivo"
        filled
        prepend-icon="mdi-camera"
    ></v-file-input>    

    <v-flex>
    <v-textarea
        solo
        name="input-7-4"
        v-model="commentary"
        :rules="commentaryRules"
        label="Favor de Explicar Brevemente su Comentario..."
    ></v-textarea>
    </v-flex>

    <v-checkbox
      v-model="checkbox"
      :rules="[v => !!v || 'You must agree to continue!']"
      label="Do you agree?"
      required
    ></v-checkbox>

  <div class="text-xs-center">

    <v-btn block
      :disabled="!valid"
      color="primary"
      class="mr-4"
      @click="validate"
    >
      Enviar
    </v-btn>
    <br>
    <v-btn block
      color="error"
      class="mr-4"
      @click="reset"
    >
      Cancelar
    </v-btn>

<!--     <v-btn
      color="warning"
      @click="resetValidation"
    >
      Reset Validation
    </v-btn> -->

  </div>


  </v-form>

    </v-container> 

</template>
 

<script> 
  export default {
    data: () => ({
      valid: true,
      name: '',
      nameRules: [
        v => !!v || 'Nombre Completo es requerido',
        v => (v && v.length <= 100) || 'El nombre completo debe tener menos de 50 caracteres',
      ],
      email: '',
      emailRules: [
        v => !!v || 'Correo electrónico es requerido',
        v => /.+@.+\..+/.test(v) || 'Correo electrónico es requerido',
      ],
      select: 'Quejas y Sugerencias',
      items: [
        'Servicio al Cliente',
        'productos en Malas Condiciones',
        'Queja',
        'Sugerencia',
        'Quejas y Sugerencias',
       
      ],

      commentary: '',
      commentaryRules: [
        v => !!v || 'Comentario es requerido',
        v => (v && v.length <= 100) || 'El comentario debe tener menos de 50 caracteres',
      ],

      checkbox: false,
    }),

    methods: {
      validate () {
        this.$refs.form.validate()
      },
      reset () {
        this.$refs.form.reset()
      },
      resetValidation () {
        this.$refs.form.resetValidation()
      },
    },
  }
</script>
