<style>
  .custom-loader {
    animation: loader 1s infinite;
    display: flex;
  }
  @-moz-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @-webkit-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @-o-keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
  @keyframes loader {
    from {
      transform: rotate(0);
    }
    to {
      transform: rotate(360deg);
    }
  }
</style>
<template>
  <div>

    <v-container> 
        <v-btn  v-if="isCrud" icon color="blue" @click="returnTable()"> <v-icon>mdi-arrow-left</v-icon>Regresar</v-btn>
        <v-divider class="my-2"></v-divider>
        <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
            {{msgError}}
        </v-alert>
    </v-container> 

    <v-container v-if="!isCrud"> 
        <template> 
            <div>
                <div class="text-center">

                    <v-dialog
                      v-model="dialog"
                      persistent
                      max-width="600px"
                    >
                      <template v-slot:activator="{ on, attrs }">
                        <v-btn
                          color="success"
                          dark
                          v-bind="attrs"
                          v-on="on"
                        >
                          Nuevo
                        </v-btn>
                      </template>

                      <v-card>
                        <v-card-title>
                          <span class="text-h5">Pregunta</span>
                        </v-card-title>
                        <v-card-text>
                          <v-container>
                            <v-row>

                                <v-container style="justify:left;width: 90%">
                                    <v-form
                                      ref="form"
                                      v-model="valid"
                                      lazy-validation
                                    >
                                    
                                    <v-text-field
                                      label="Pregunta"
                                      v-model="pregunta.pregunta"
                                      :rules="rules"
                                      hide-details="auto"
                                    ></v-text-field>
                                    <br>
                                    <v-flex>
                                      <v-textarea
                                          solo
                                          name="input-7-4"
                                          v-model="pregunta.descripcion"
                                          :rules="commentaryRules"
                                          label="Escribir una Breve Descripción..."
                                      ></v-textarea>
                                    </v-flex>

                                    <v-btn block 
                                      :disabled="!valid"
                                      color="primary"
                                      class="mr-4"
                                      @click="registrar()"
                                    >Crear</v-btn>

                                    <br>
                                    <v-btn block
                                      color="error"
                                      class="mr-4"
                                      @click="reset"
                                    >Cancelar
                                    </v-btn>
                                    <br>

                                    <v-btn block
                                      color="secondary"
                                      class="mr-4"
                                      @click="cerrarModalPregunta()"
                                    >Cerrar
                                    </v-btn>         

                                    </v-form>
                                </v-container>

                            </v-row>
                          </v-container>
                        </v-card-text>
                      </v-card>
                    </v-dialog>

                  <v-btn
                    class="ma-2"
                    :loading="loading4"
                    :disabled="loading4"
                    color="info"
                    @click="loader = 'loading4',refresh()"
                  > Recargar
                    <template v-slot:loader>
                      <span class="custom-loader">
                        <v-icon light>mdi-cached</v-icon>
                      </span>
                    </template>
                  </v-btn>

                </div>
            </div>
            <br>
            <!-- MUESTRA TODAS LAS PREGUNTAS -->
            <v-card>
                <v-card-title>
                    <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line hide-details
                    ></v-text-field>
                </v-card-title>
                <v-data-table
                    no-data-text="No hay datos disponibles"
                    no-results-text="No hay coincidencias de tu busqueda."
                    :footer-props="{'items-per-page-options': [20,30,40,50]}"
                    :headers="headers" :items="ventas" :search="search">
                    <template v-slot:[`item.actions`]="{ item }">
                        <center>
                            <v-icon color="green darken-2" medium @click="crud(item)">
                                mdi-chat-processing
                            </v-icon>
                        </center>
                    </template>
                </v-data-table>
            </v-card>
            <!-- MUESTRA TODAS LAS PREGUNTAS -->
            
        </template>
    </v-container>

      <!-- PREGUNTA PRINCIPAL -->
      <v-container v-if="isCrud">
        
        <form > 
               <v-card
                  class="mx-auto"
                  max-width="1600"
                  elevation="2"
                  outlined
                  shaped
                >

                <v-card-text>
                  <div>Pregunta:</div>
                  <p class="text-h4 text--primary">
                    {{pregunta.pregunta}}
                  </p>
                  <p>Descripción:</p>
                  <div class="text-h6">
                    {{pregunta.descripcion}}
                  </div>
                </v-card-text>

                <v-card-actions>
                  <v-btn
                    disabled
                    elevation="2"
                    outlined
                    raised
                    rounded
                    label="Activo"

                  >{{pregunta.nombre_usuarios}}</v-btn>

                  <v-btn
                    disabled
                    elevation="2"
                    outlined
                    raised
                    rounded
                    label="Activo"

                  >{{pregunta.created_at}}</v-btn>

                  <v-switch
                    v-model="ex11"
                    label="Activo"
                    color="primary"
                    value="primary"
                  ></v-switch>
                </v-card-actions>
              </v-card>
          <!-- PREGUNTA PRINCIPAL -->
              <br>
          <!-- CONSULTA DE RESPUESTAS -->            
              <v-container>
              
                <v-col>
                  <v-row>
                    <v-col v-for="r in resultadorespuesta" :key="r._id">
                      <v-card
                      class="mx-auto"
                      max-width="1100"
                      outlined
                      elevation="2"
                      shaped
                      >
                      
                      <v-card-text>
                        <div>Respuesta:</div>
                        <div class="text-h6">
                          {{r.respuesta}}
                        </div>
                      </v-card-text>
                      <v-card-actions>
                            <v-btn
                              disabled
                              elevation="2"
                              outlined
                              raised
                              rounded
                              label="Activo"

                            >{{r.nombre_usuarios}}</v-btn>

                            <v-btn
                              disabled
                              outlined
                              raised
                              rounded
                              label="Activo"

                            >{{r.created_at}}</v-btn>

                            <v-switch
                              v-model="ex11"
                              label="Activo"
                              color="primary"
                              value="primary"
                            ></v-switch>
                      </v-card-actions>
                      </v-card>
                    </v-col>
                  </v-row>

                </v-col>
              
              </v-container>
            
          <!-- CONSULTA DE RESPUESTAS -->

              <!-- RESPONDER FORO -->
                <v-container style="justify:left;width: 80%">    
                    <v-form
                      ref="form"
                      v-model="valid"
                      lazy-validation
                    >
                    <v-flex>
                      <v-textarea
                          solo
                          name="input-7-4"
                          v-model="respuesta.respuesta"
                          :rules="commentaryRules"
                          label="Comentario ...."
                      ></v-textarea>
                    </v-flex>

                    <v-btn block 
                      :disabled="!valid"
                      color="primary"
                      class="mr-4"
                      @click="registrarRespuesta()"
                    >Crear</v-btn>

                    <br>
                    <v-btn block
                      color="error"
                      class="mr-4"
                      @click="reset"
                    >Cancelar
                    </v-btn>

                    </v-form>
                </v-container> 
              <!-- RESPONDER FORO -->
        </form>
    </v-container> 

  </div>
</template>

<script>
  import axios from 'axios'; 
  import config from '../../json/config.json'; 


  export default {
    data: () => ({

      loader: null,
      loading: false,
      loading2: false,
      loading3: false,
      loading4: false,
      loading5: false,

      search: '',
      headers: [
        { text: 'Pregunta', value: 'Pregunta' },
        { text: 'Usuario', value: 'Usuario'},   
        { text: 'Fecha', value: 'creat_at'},   
        { text: 'Comentarios', value: 'actions', sortable: false },
      ], 
      isCrud:false,
      msgError:'',
      users:{},
      isLogged : false,      
      ex11: ['red', 'indigo', 'orange', 'primary', 'secondary', 'success', 'info', 'warning', 'error', 'red darken-3', 'indigo darken-3', 'orange darken-3'],

      valid: true,
      dialog: false,

      ventas:[],
      pregunta:{
        pregunta: "",
        descripcion: "",
        estado : "Pendiente",
        created_by : "",
        nombre_usuarios : ""
      },

      rules: [
        value => !!value || 'Requerido.',
        value => (value && value.length >= 10) || 'Mínimo 20 Caracteres',
      ],

      commentary: '',
      commentaryRules: [
        v => !!v || 'Comentario es requerido',
        v => (v && v.length <= 1000) || 'El comentario debe tener menos de 50 caracteres',
      ],

      resultadorespuesta:[],
      respuesta:{
        numeropregunta: "",
        respuesta: "",
        activo: false,
        calificacion: "10",
        created_by : "",
        nombre_usuarios: ""
      },


    }),

    async created(){  
       await this.mostrarTodasPreguntas(); 
       await this.validaLogin(); 
       
    }, 

    watch: {
      loader () {
        const l = this.loader
        this[l] = !this[l]

        setTimeout(() => (this[l] = false), 3000)

        this.loader = null
      },
    },

    methods: {
      validate () {
        this.$refs.form.validate()
      },
      reset () {
          this.pregunta = [];
      },

      returnTable(){
          this.isCrud = false;
          this.msgError = "";
          this.pregunta = [];

      },

      cerrarModalPregunta(){
          this.dialog = false
          this.reset();
      },

      formatDate(dates) {
          if (dates === undefined)return "Error de Fecha" 
          try {
              var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
              let date = new Date(Date.parse(dates));  
              return `${date.getDate()} de ${month[date.getMonth()]} del ${date.getFullYear()}`;
          } catch (error) {
              console.log(error);
              return "Error de Fecha";
          }
      },

    async mostrarTodasPreguntas(){ 
        this.isLoad = true;
        this.ventas = await axios.get(config.apiAdempiere + "/foro/get_all",
        { headers:{token: this.$cookie.get('token')}, data:{filer: {}}})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});
        if (this.ventas.status == "success") {
            this.ventas = this.ventas.data; 
            for (let index = 0; index < this.ventas.length; index++) { 
                //this.ventas[index].fechaprometidaFormato = this.formatDate(this.ventas[index].fechaprometida);
                this.ventas[index].Pregunta = this.ventas[index].pregunta;
                this.ventas[index].Usuario = this.ventas[index].nombre_usuarios;
                this.ventas[index].creat_at = this.formatDate(this.ventas[index].created_at);
            }
        }
        this.isLoad = false;
        
    },

    async refresh(){
        await this.mostrarTodasPreguntas(); 
    },

    async registrar() {
            this.msgError = "";
            this.pregunta.created_by = this.user.ad_user_id;
            this.pregunta.nombre_usuarios = this.user.cpname;

            const result = await axios.post(config.apiAdempiere + "/foro/add_question",this.pregunta
            ,{headers:{token: this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
                
            }).catch(err=>{
                console.log(err);
                return false;
            });

            console.log(result);
            this.dialog = false,
            this.pregunta = "";
            this.mostrarTodasPreguntas();
    },

    async crud(item){
        this.msgError = "";
        this.isCrud = true;
        this.pregunta = item;
        this.respuesta.numeropregunta = item.numeropregunta;
        this.mostrarRespuestasPreguntas(item.numeropregunta)

    }, 

      /////////////////////// RESPUESTAS //////////////////////
        async mostrarRespuestasPreguntas(item){ 
          console.log(item);
            this.isLoad = true;
            this.resultadorespuesta = await axios.get(config.apiAdempiere + "/foro/get_all_answer",
            { headers:{token: this.$cookie.get('token')}, params: {numeropregunta: item} } )
            .then(res=>{return res.data;})
            .catch(err=>{return err;});
            
            if (this.resultadorespuesta.status == "success") {
                this.resultadorespuesta = this.resultadorespuesta.data; 

            }
            this.isLoad = false;
        },

    async registrarRespuesta() {
            this.msgError = "";
            // console.log(JSON.stringify(this.solicitud));
            //this.respuesta.numeropregunta = this.respuesta.numeropregunta;
            this.respuesta.created_by = this.user.ad_user_id;
            this.respuesta.nombre_usuarios = this.user.cpname;
            const result = await axios.post(config.apiAdempiere + "/foro/add_answer",this.respuesta

            ,{headers:{token: this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
            }).catch(err=>{
                console.log(err);
                return false;
            });
            console.log(result);
            this.mostrarRespuestasPreguntas( this.respuesta.numeropregunta );
            this.respuesta.respuesta = "";            
    },
      /////////////////////// RESPUESTAS //////////////////////
    async validaLogin(){
              this.user = await axios.get(config.apiAdempiere + "/user/userByTokenAdmin", 
              {
                'headers': { 'token': this.$cookie.get('token') }
              }).then(res=>{return res.data;})
              .catch(err=>{return err;});
              if (this.user.status == "success") {
                this.user = this.user.user;
                this.isLogged = true; 
              }else if(this.user.status == "unauthorized"){ 
                this.isLogged = false;
              } 
          }
    },
  }
</script>
