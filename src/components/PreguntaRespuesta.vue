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
        <!-- CONSULTA DE RESPUESTAS -->
        <v-app>
            <v-container> 
                <v-btn  v-if="esRespuesta" icon color="blue" @click="returnTable()"> <v-icon>mdi-arrow-left</v-icon>Regresar</v-btn>
                <v-divider class="my-2"></v-divider>
                <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
                    {{msgError}}
                </v-alert>
            </v-container>
  
            <v-container v-if="!esRespuesta">
              
              <v-card-title>
                  <v-spacer></v-spacer>
                    <v-text-field
                      label="Búsqueda Pregunta..."
                      single-line
                      hide-details
                      v-model="search"
                    ></v-text-field>
                    <v-col class="text-right">
                    <v-btn
                      depressed
                      color="success"
                      @click="filterSearch()"
                    >Buscar 
                    </v-btn>
                    </v-col>
              </v-card-title>


                <v-col>
                  <v-row>
                    <v-col v-for="r in ventas" :key="r._id" cols="12">
                      <v-card
                      class="mx-auto"
                      max-width="1100"
                      outlined
                      elevation="2"
                      shaped
                      >
                      
                <v-card-text>
                  <div>Pregunta:</div>
                  <p class="text-h4 text--primary">
                    {{r.pregunta}}
                  </p>
                  <p>Descripción:</p>
                  <div class="text-h6">
                    {{r.descripcion}}
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
                              disabled
                            ></v-switch>


                            <v-col class="text-right">
                            <v-btn
                              depressed
                              color="primary"
                              @click="crud(r)"
                            >
                              Ver Comentarios
                            </v-btn>
                            </v-col>

                      </v-card-actions>
                      </v-card>
                    </v-col>
                  </v-row>

                </v-col>
              
              </v-container>


 <!-- PREGUNTA PRINCIPAL -->
      <v-container v-if="esRespuesta">
        
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
                    disabled

                  ></v-switch>
                </v-card-actions>
              </v-card>


        <v-container>
              
                <v-col>
                  <v-row>
                    <v-col v-for="r in respuestas" :key="r._id" cols="12">
                      <v-card
                      class="mx-auto"
                      max-width="1100"
                      outlined
                      elevation="2"
                      shaped
                      disabled
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




              </v-container>

              
            
            </v-app>
          <!-- CONSULTA DE RESPUESTAS -->
</template>
 

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'; 

  export default {
    data: () => ({

      ex11: ['red', 'indigo', 'orange', 'primary', 'secondary', 'success', 'info', 'warning', 'error', 'red darken-3', 'indigo darken-3', 'orange darken-3'],

      search:"",
      valid: true,
      name: '',
      nameRules: [
        v => !!v || 'Nombre Completo es requerido',
        v => (v && v.length <= 100) || 'El nombre completo debe tener menos de 50 caracteres',
      ],

       id : "",

      commentary: '',
      commentaryRules: [
        v => !!v || 'Comentario es requerido',
        v => (v && v.length >= 20) || 'El comentario debe tener menos de 20 caracteres',
      ],

      esRespuesta:false,
      msgError:'',

      respuestas:[],
      respuesta:{
        numeropregunta: "",
        respuesta: "",
        activo: true,
        calificacion: "10",
        created_by : "",
        nombre_usuarios: ""
      },


      ventas:[],
      accounts : [],  

      users:{},
      isLogged : false,

      preguntaGeneral:'',


    }),

    async created(){  
       await this.mostrarTodasPreguntas(); 
       await this.validaLogin(); 

    }, 

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

      returnTable(){
          this.esRespuesta = false;
          this.msgError = "";
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

            }
            this.isLoad = false;
        },

        async refresh(){
            await this.mostrarTodasPreguntas();
                        this.filterSearch();

        },

      async filterSearch(){ 
          this.ventas = [];
          //console.log(this.search);
          
          this.isLoad = true;
          this.ventas = await axios.get(config.apiAdempiere + "/foro/get_question",
          { headers:{token: this.$cookie.get('token')}, params: {pregunta : this.search } } )
          .then(res=>{return res.data;})
          .catch(err=>{return err;});
          
          if (this.ventas.status == "success") {
              this.ventas = this.ventas.data; 
          }
          this.isLoad = false;
      },


        async crud(item){
            this.msgError = "";
            this.esRespuesta = true;
            this.pregunta = item;
            this.respuesta.numeropregunta = item.numeropregunta;
            //this.preguntaGeneral = item.numeropregunta;
            this.mostrarRespuestasPreguntas(item.numeropregunta)

        }, 
      /////////////////////// RESPUESTAS //////////////////////
        async mostrarRespuestasPreguntas(item){ 
            //console.log(item);
            this.isLoad = true;
            this.respuestas = await axios.get(config.apiAdempiere + "/foro/get_all_answer",
            { headers:{token: this.$cookie.get('token')}, params: {numeropregunta: item} } )
            .then(res=>{return res.data;})
            .catch(err=>{return err;});
            
            if (this.respuestas.status == "success") {
                this.respuestas = this.respuestas.data; 
            }
            this.isLoad = false;
        },

    async registrarRespuesta() {
            this.msgError = "";
            // console.log(JSON.stringify(this.solicitud));
            //this.respuesta.numeropregunta = this.respuesta.numeropregunta;
            this.respuesta.created_by = this.user.ad_user_id;
            this.respuesta.nombre_usuarios = this.user.cpname;

            const result = await axios.post(config.apiAdempiere + "/foro/add_answer_user",this.respuesta

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

    async validaLogin(){
            this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
            {'headers': { 'token': this.$cookie.get('token') }})
            .then(res=>{return res.data;})
            .catch(err=>{return err;});    
            if (this.user.status == "success") {
              this.user = this.user.user;
              this.isLogged = true;
            }else if(this.user.status == "unauthorized"){ 
              this.isLogged = false;
              location.href = "/shop/Login";
            }  
            console.log( this.user); 
        },

    },
  }
</script>
