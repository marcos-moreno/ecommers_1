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
          <v-btn  v-if="esRespuesta" icon color="blue" @click="returnTable()"> <v-icon>mdi-arrow-left</v-icon>Regresar</v-btn>
          <v-divider class="my-2"></v-divider>
          <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
              {{msgError}}
          </v-alert>
      </v-container>

      <v-container v-if="!esRespuesta"> 
              <div>
                  <div class="text-center">

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
              <!-- MUESTRA TODAS LAS QUEJAS -->
              <v-card>
                  <v-card-title>
                      <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line hide-details
                      ></v-text-field>
                  </v-card-title>
                  <v-data-table
                      no-data-text="No hay datos disponibles"
                      no-results-text="No hay coincidencias de tu busqueda."
                      :footer-props="{'items-per-page-options': [20,30,40,50]}"
                      :headers="headers" :items="quejas" :search="search">
                      <template v-slot:[`item.actions`]="{ item }">
                          <center>
                              <v-icon color="green darken-2" medium @click="crud(item)">
                                  mdi-chat-processing
                              </v-icon>
                          </center>
                      </template>
                  </v-data-table>
              </v-card>
              <!-- MUESTRA TODAS LAS QUEJAS -->

      </v-container>

      <!-- PREGUNTA PRINCIPAL -->
      <v-container v-if="esRespuesta">
        <form > 
               <v-card
                  class="mx-auto"
                  max-width="1600"
                  elevation="24"
                  outlined
                  shaped
                >

                <v-card-text>
                  <div>Servicio:</div>
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

                  <v-switch
                    v-model="ex11"
                    label="Activo"
                    color="primary"
                    value="primary"
                  ></v-switch>
                </v-card-actions>
              </v-card>
          <!-- PREGUNTA PRINCIPAL -->

          <!-- CONSULTA DE RESPUESTAS -->            
              <v-container>
                <v-col>
                  <v-row>
                    <v-col v-for="r in respuestas" :key="r._id">
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
                            >{{r.nombre_usuario}}</v-btn>

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
                      v-model="validarFormulario"
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
                      :disabled="!validarFormulario"
                      color="success"
                      class="mr-4"
                      @click="registrarRespuesta()"
                    >Responder</v-btn>

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

      esRespuesta:false,
      msgError:'',
      users:{},
      isLogged : false,

      validarFormulario : true,
      commentary: '',
      commentaryRules: [
        v => !!v || 'Comentario es requerido',
        v => (v && v.length >= 15) || 'El comentario debe tener menos de 50 caracteres',
      ],

      search: '',
      quejas:[],      
      headers: [
        { text: 'Servicio', value: 'Servicio' },
        { text: 'Usuario', value: 'Usuario'},   
        { text: 'Fecha', value: 'creat_at'},   
        { text: 'Comentarios', value: 'actions', sortable: false },
      ], 

      select: 'Quejas y Sugerencias',
      items: [
        'Servicio al Cliente',
        'productos en Malas Condiciones',
        'Queja',
        'Sugerencia',
        'Quejas y Sugerencias',
      ],

      respuestas:[],
      respuesta:{
        numero_queja: "",
        respuesta: "",
        activo: true,
        created_by : "",
        nombre_usuario: ""
      },      

      loading4: false,
      ex11: ['red', 'indigo', 'orange', 'primary', 'secondary', 'success', 'info', 'warning', 'error', 'red darken-3', 'indigo darken-3', 'orange darken-3'],
      


    }),

    async created(){  
       await this.mostrarTodasQuejas(); 
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

    reset () {
        this.$refs.form.reset()
    },

    returnTable(){
        this.esRespuesta = false;
        this.msgError = "";
        //this.pregunta = [];
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

    async crud(item){
        this.msgError = "";
        this.esRespuesta = true;
        this.queja = item;
        this.respuesta.numero_queja = item.numero_queja;
        this.mostrarRespuestasQuejas(item.numero_queja)
        console.log(this.quejas.numero_queja);

    },

    async refresh(){
        await this.mostrarTodasQuejas(); 
    },

    async mostrarTodasQuejas(){ 
        this.isLoad = true;
        this.quejas = await axios.get(config.apiAdempiere + "/queja/get_all",
        { headers:{token: this.$cookie.get('token')}, data:{filer: {}}})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});
        if (this.quejas.status == "success") {
            this.quejas = this.quejas.data; 
            for (let index = 0; index < this.quejas.length; index++) { 
                //this.ventas[index].fechaprometidaFormato = this.formatDate(this.ventas[index].fechaprometida);
                this.quejas[index].Servicio = this.quejas[index].tema;
                this.quejas[index].Usuario = this.quejas[index].nombre_usuario;
                this.quejas[index].creat_at = this.formatDate(this.quejas[index].created_at);
            }
        }
        this.isLoad = false;
        
    },

    /////////////////////// RESPUESTAS //////////////////////
    async mostrarRespuestasQuejas(item){ 
        //console.log(item);
        this.isLoad = true;
        this.respuestas = await axios.get(config.apiAdempiere + "/queja/get_all_answer",
        { headers:{token: this.$cookie.get('token')}, params: {numero_queja: item} } )
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
            //this.respuesta.numero_queja = this.respuesta.numero_queja;
            this.respuesta.created_by = this.user.ad_user_id;
            this.respuesta.nombre_usuario = this.user.cpname;
            const result = await axios.post(config.apiAdempiere + "/queja/add_answer_admin",this.respuesta

            ,{headers:{token: this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
            }).catch(err=>{
                console.log(err);
                return false;
            });
            console.log(result);
            this.mostrarRespuestasQuejas( this.respuesta.numero_queja );
            this.respuesta.respuesta = "";            
    },

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
