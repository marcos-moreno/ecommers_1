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

      <v-container style="justify:left;width: 98%">

        <v-container> 
            <v-btn  v-if="esRespuesta" icon color="blue" @click="datosTabla()"> <v-icon>mdi-arrow-left</v-icon>Regresar</v-btn>
            <v-divider class="my-2"></v-divider>
            <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
                {{msgError}}
            </v-alert>
        </v-container>


        <v-container v-if="!esRespuesta">
        
          <v-col>
            <v-row>
              <v-col v-for="r in quejas" :key="r._id" cols="12">
                <v-card
                class="mx-auto"
                max-width="1100"
                outlined
                elevation="24"
                shaped
                >
                
          <v-card-text>
            <p class="text-h4 text--primary">
              {{r.tema}}
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
                        color="orange"
                        text

                      >{{r.nombre_usuario}}</v-btn>

                      <v-btn
                        disabled
                        elevation="2"
                        color="orange"
                        text

                      >{{r.created_at}}</v-btn>


                      <v-col class="text-right">
                      <v-btn
                        color="secondary"
                        elevation="2"
                        outlined
                        rounded
                        @click="crud(r)"
                      >
                        Historial
                      </v-btn>
                      </v-col>

                </v-card-actions>
                </v-card>
              </v-col>
            </v-row>
          </v-col>        
        </v-container>


        <v-row justify="center" v-if="!esRespuesta">
          <v-dialog
            v-model="dialog"
            persistent
            max-width="600px"
          >

            <template v-slot:activator="{ on, attrs }">
              <v-col class="text-center" cols="12">
              <v-btn
                color="red"
                dark
                large
                v-bind="attrs"
                v-on="on"
                rounded
                
              ><v-icon>mdi-pencil</v-icon>
                Nuevo 
              </v-btn>
              </v-col>
            </template>
            <v-card>
              <v-card-title>
                <span class="text-h7">Servicio...</span>
              </v-card-title>
              <v-card-text>
                <v-container>
                  <v-row>

                    <v-col cols="12">
                        <v-select
                          v-model="queja.tema"
                          :items="items"
                          :rules="[v => !!v || 'Tema es obligatorio']"
                          label="Tema"
                          required
                          
                        ></v-select>
                    </v-col>

                    <v-col cols="12">
                        <v-textarea
                            solo
                            v-model="queja.descripcion"
                            :rules="commentaryRules"
                            label="Favor de Explicar Brevemente su Comentario..."
                        ></v-textarea>

                    </v-col>

                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                  color="blue darken-1"
                  text
                  @click="cerrarModal()"
                >
                  Cerrar
                </v-btn>
                <v-btn
                  color="blue darken-1"
                  text
                  @click="registrarQueja()"
                >
                  Guardar
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
        </v-row>


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
                  <p class="text-h4 text--primary">
                    {{queja.tema}}
                  </p>
                  <p>Descripción:</p>
                  <div class="text-h6">
                    {{queja.descripcion}}
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
                  >{{queja.nombre_usuario}}</v-btn>

                  <v-btn
                    disabled
                    elevation="2"
                    outlined
                    raised
                    rounded
                    label="Activo"
                  >{{queja.created_at}}</v-btn>
                </v-card-actions>
              </v-card>


              <v-container>
                <v-col>
                  <v-row>
                    <v-col v-for="r in quejasrespuestas" :key="r._id" cols="12">
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
                            >{{r.nombre_usuario}}</v-btn>

                            <v-btn
                              disabled
                              outlined
                              raised
                              rounded
                              label="Activo"
                            >{{r.created_at}}</v-btn>

                      </v-card-actions>
                      </v-card>
                    </v-col>
                  </v-row>
                </v-col>
              </v-container>
        </v-container>
        <!-- PREGUNTA PRINCIPAL -->


        <!-- RESPONDER FORO -->
          <v-container style="justify:left;width: 80%" v-if="esRespuesta">    
              <v-form
                ref="form"
                v-model="valid"
                lazy-validation
              >


              <v-flex>
                <v-textarea
                    solo
                    name="input-7-4"
                    v-model="quejarespuesta.respuesta"
                    :rules="commentaryRules"
                    label="Comentario ...."
                ></v-textarea>
              </v-flex>

              <v-btn block 
                :disabled="!valid"
                color="primary"
                class="mr-4"
                @click="registrarRespuestaUsuario()"
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
</template>
 

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'; 

  export default {
    data: () => ({

      users:{},
      isLogged : false,
      valid: true,
      esRespuesta:false,
      msgError:'',
      ex11: ['red', 'indigo', 'orange', 'primary', 'secondary', 'success', 'info', 'warning', 'error', 'red darken-3', 'indigo darken-3', 'orange darken-3'],

      select: 'Quejas y Sugerencias',
      items: [
        'Servicio al Cliente',
        'Productos en Malas Condiciones',
        'Queja',
        'Sugerencia',
        'Otro',
       
      ],

      commentary: '',
      commentaryRules: [
        v => !!v || 'El comentario debe tener menos de 50 caracteres',
        v => (v && v.length >= 20) || 'El comentario debe tener menos de 50 caracteres',
      ],

      dialog: false,  
      quejas:[],
      queja:{
        numero_queja: "",
        tema: "",
        descripcion: "",
        estado: "Pendiente",
        created_by : "",
        nombre_usuario: ""
      },      
      
      quejasrespuestas:[],
      quejarespuesta:{
        numero_queja: "",
        respuesta: "",
        activo: true,
        created_by : "",
        nombre_usuarios: ""
      },



    }),

    async created(){ 
        await this.validaLogin(); 
       await this.mostrarQuejasUsuario(); 

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

      cerrarModal(){
        this.dialog = false
        this.commentary = "";
        //this.queja ="";
      },      

      datosTabla(){
          this.esRespuesta = false;
          this.msgError = "";
          this.queja ="";
          //this.mostrarQuejasUsuario();
      },

    async crud(item){
        //console.log(item.numero_queja)
        this.msgError = "";
        this.esRespuesta = true;
        this.queja = item;
        //this.queja.numero_regunta = item.numero_pregunta;
        //this.preguntaGeneral = item.numeropregunta;
        this.mostrarQuejasRespuestaUsuario(item.numero_queja);
    }, 

    async refresh(){
        await this.mostrarQuejasUsuario(); 
    },

    async mostrarQuejasUsuario(){ 
        this.isLoad = true;
        let users= this.user.ad_user_id;
        console.log(users);

        this.quejas = await axios.get(config.apiAdempiere + "/queja/get_user_complain",
        { headers:{token: this.$cookie.get('token')}, params:{created_by: users }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});
        if (this.quejas.status == "success") {
            this.quejas = this.quejas.data;

        }
        this.isLoad = false;
    },


    async registrarQueja() {
           this.msgError = "";
            // console.log(JSON.stringify(this.solicitud));
            this.queja.created_by = this.user.ad_user_id;
            this.queja.nombre_usuario = this.user.cpname;


            const result = await axios.post(config.apiAdempiere + "/queja/add_complain",this.queja
            ,{headers:{token: this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
                
            }).catch(err=>{
                console.log(err);
                return false;
            });

            console.log(result);
            this.dialog = false;
            this.mostrarQuejasUsuario();
    },

    async mostrarQuejasRespuestaUsuario(item){
        //console.log(item);
        this.isLoad = true;
        this.quejasrespuestas = await axios.get(config.apiAdempiere + "/queja/get_user_specific_complain",
        { headers:{token: this.$cookie.get('token')}, params: {numero_queja: item} } )
        .then(res=>{return res.data;})
        .catch(err=>{return err;});
        
        if (this.quejasrespuestas.status == "success") {
            this.quejasrespuestas = this.quejasrespuestas.data; 
        }
        this.isLoad = false;
    },

    async registrarRespuestaUsuario() {

            this.msgError = "";
            // console.log(JSON.stringify(this.solicitud));
            this.quejarespuesta.numero_queja = this.queja.numero_queja;
            this.quejarespuesta.created_by = this.user.ad_user_id;
            this.quejarespuesta.nombre_usuario = this.user.cpname;

            const result = await axios.post(config.apiAdempiere + "/queja/add_user_specific_complain",this.quejarespuesta

            ,{headers:{token: this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
            }).catch(err=>{
                console.log(err);
                return false;
            });
            console.log(result);

            this.mostrarQuejasRespuestaUsuario(this.quejarespuesta.numero_queja)
            this.quejarespuesta.respuesta = "";
            //this.mostrarRespuestasPreguntas(this.preguntaGeneral);
            //this.quejarespuesta.respuesta = "";
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
            //console.log( this.user); 
        },

        validaQuejaGeneral(){
            if (this.queja.descripcion != "" && this.queja.descripcion.length > 25) {
                this.error.descripcion = "";
                return true;
            }else{
                this.error.descripcion = "Nombre Requerido";
                return false;
            } 
        },



 









    },






  }
</script>
