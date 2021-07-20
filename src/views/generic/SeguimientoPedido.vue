<template>
<div>
<app-menu/>
 <v-container class="grey lighten-5" style="min-height:756px;">
    <v-alert v-if="alert.showAlery" :type="alert.typeAlert">{{alert.msg}}</v-alert>
    <div class="text-center"> 
      <v-dialog v-model="isLoad" persistent width="300">
         <v-card color="primary" dark >
          <v-card-text>
            cargando
            <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
          </v-card-text>
        </v-card> 
      </v-dialog>
    </div>
    <v-container>
      <v-card class="mx-auto" max-width="500" v-if="comprobado==false" >
        <v-card-text>
          <div>Seguimiento de pedido</div>
          <p class="text-h5 text--secondary">
            Ingresa o escanea el No. de Orden
          </p> 
          <v-text-field label="Orden" @keyup="uppercase()" 
            hide-details="auto" v-model="req_sol.no_orden"
            @keyup.enter.native="validaOrden()"
          >
          </v-text-field> 
        </v-card-text>
        <br>
        <v-card-actions>
          <v-btn text color="teal accent-4" @click="validaOrden()">
            Buscar
          </v-btn>
        </v-card-actions>
        <v-expand-transition>
          <v-card v-if="solicitacode" class="transition-fast-in-fast-out v-card--reveal" style="height: 100%;">
            <v-card-text class="pb-0">
              <p class="text-h5 text--secondary">
                <v-btn icon color="blue" @click="solicitacode = false; alert.showAlery = false"> 
                  <v-icon>mdi-arrow-left</v-icon>
                </v-btn>
                Código de seguridad
              </p>
              <p>
                Para agregar un estado a la entrega <strong>{{req_sol.no_orden}}</strong> es necesario un
                código de seguridad que debé ser proporcionado por un administrador
              </p> 
              <v-text-field
                v-model="req_sol.code_seguridad" :append-icon="showCode ? 'mdi-eye' : 'mdi-eye-off'" 
                :type="showCode ? 'text' : 'password'" name="input-10-1" label="Código de seguridad"
                hint="Ingresa 5 digitos" counter
                @click:append="showCode = !showCode"
                @keyup.enter.native="buscarOrden()"
              ></v-text-field> 
            </v-card-text>
            <br><br>
            <v-card-actions class="pt-0">
              <v-btn color="primary" @click="buscarOrden()">
                Validar
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-expand-transition>
        <br><br><br><br>
      </v-card> 

      <div v-if="comprobado == true"> 
        <v-row>
          <v-col cols="12" sm="6">
            <v-card class="mx-auto" max-width="500" min-height="300">  
                <v-card  class="transition-fast-in-fast-out v-card--reveal" style="height: 100%;">
                  <v-card-text class="pb-0">
                    <p class="text-h5 text--secondary">
                      <v-btn icon color="blue" @click="comprobado = false;alert.showAlery = false"> 
                        <v-icon>mdi-arrow-left</v-icon>
                      </v-btn>
                      Cambiar estado de la orden
                    </p>
                    <p>
                      Para agregar un estado a la entrega <strong>{{req_sol.no_orden}}</strong>
                    </p>   
                    <!-- {{entregas}} -->
                    <v-select
                      v-model="valor_entrega"
                      :items="entregas"
                      label="Entregas"
                      item-text="entrega_doc"
                      item-value="estados.entrega_doc"
                       @change="cambioEntrega()"
                    ></v-select>  

                    <v-select   
                      v-model="estado.value"
                      :items="catalogo_estados"
                      label="Estado"
                      item-text="name"
                      item-value="value"
                    ></v-select> 
                  </v-card-text> 

                  <v-card-actions class="pt-0"> 
                    <v-btn color="primary" @click="cambiarEstado()">
                      Agregar Estado
                    </v-btn>
                  </v-card-actions> 

                </v-card>  
              </v-card>  
          </v-col>
              <!-- {{entrega.estados}} -->

          <v-col  cols="12" sm="6">
            <v-card class="mx-auto" max-width="500" >  
              <!-- <v-card class="transition-fast-in-fast-out v-card--reveal" style="height: 100%;"> -->
              <template v-if="entrega.estados.length > 0"> 
                <v-stepper  vertical  v-if="entrega.estados.length > 0">
                  <template v-for="(estado, index) in  entrega.estados" :step="(index+2).toString()">
                    <v-stepper-step complete :step="(index+2).toString()" :key="'step-'+index+2"> 
                      {{estado.name}}
                      <small>{{formatDate(estado.datetrx)}}</small>
                    </v-stepper-step> 
                    <v-stepper-content :step="(index+2).toString()" :key="'cont-'+index+2"> 
                    </v-stepper-content>
                  </template>
                </v-stepper>  
              </template> 
              <center v-else>  
                  <br>
                  Aún no hay estados 
              </center>
              </v-card>  
            <!-- </v-card>   -->
          </v-col>

        </v-row>
      </div>
 
    <v-spacer class="my-12"></v-spacer> 
    </v-container>
  </v-container>
  </div>
</template>


<style scoped>
.v-card--reveal {
  bottom: 0;
  opacity: 1 !important;
  position: absolute;
  width: 100%;
}
</style>

<script>
import axios from 'axios'; 
import config from '../../json/config.json'
import AppMenu from '../../components/Menu.vue';

export default {
  name:"seguimiento", 
  data() {
    return {  
      user:{} 
      ,showCode: false
      ,isLogged:false
      ,isLoad:false 
      ,msgErro:'' 
      ,solicitacode: false
      ,alert:{typeAlert:"",showAlery : false,msg:""} 

      ,req_sol:{no_orden : "S27-61",code_seguridad:"0000"}

      ,entregas:[]
      ,entrega:{estados:[]}
      ,comprobado : false
      ,estado : {valor:"",value:""}
      ,catalogo_estados : [] 
      ,valor_entrega : ""
    }
  },
  components: { 
      'app-menu': AppMenu, 
  }, 
  async created(){ 
    this.get_catalogo_estagos();   
  },
  methods:{
    cambioEntrega(){
      for (let i = 0; i < this.entregas.length; i++) {
        const element = this.entregas[i];
        if (this.valor_entrega == element.entrega_doc) {
          this.entrega = element;
        }
      }  
    },
    formatDate(dates) { 
        var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
            "Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
        return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()]} del ${(new Date(Date.parse(dates))).getFullYear()}`
    },
    async cambiarEstado(){ 
      let params = {
          code_seguridad : this.req_sol.code_seguridad,
          c_order_id :this.entrega.c_order_id,
          m_inout_id :this.entrega.m_inout_id,
          rf_statusorder :this.estado.value,
        }; 
        const resultInsertEstado = 
        await axios.post(config.apiAdempiere + "/seguimientopedido/insert_estado_seguimiento", 
        params,
        {
          headers: { 'token': this.$cookie.get('token') }, 
        }).then(res=>{  
          if(res.data.status == "success"){  
            this.alert.typeAlert = "success";
            this.alert.showAlery = true;
            this.alert.msg = "Estado agregado."; 
            return true; 
          }
          if(res.data.status == "unauthorized"){  
            this.alert.typeAlert = "error";
            this.alert.showAlery = true;
            this.alert.msg = "Tu código de seguridad ha sido rechazado."; 
            return false; 
          }  
        })
        .catch(err=>{
          this.alert.typeAlert = "error";
          this.alert.showAlery = true;
          this.alert.msg = "Existe un error, por favor recarga esta página.";
          console.log(err);
          return false;
        });
        if (resultInsertEstado == true) {
          let resultEstados = await axios.get(
            config.apiAdempiere + "/seguimientopedido/estados", 
          {
            'headers': { 'token': this.$cookie.get('token') },
            params: {m_inout_id : params.m_inout_id}
          }).then(res=>{return res.data;})
          .catch(err=>{console.log(err);return false;});     
          if (resultEstados.status == "success") {
            this.entrega.estados = resultEstados.data;  
          }else{
            this.entrega.estados = [];
          }
        }   
    },
    async get_catalogo_estagos(){
        this.catalogo_estados = await axios.get(config.apiAdempiere + "/seguimientopedido/catalogo_estados", 
        {
          'headers': {'token': this.$cookie.get('token')}
        }).then(res=>{return res.data.data;})
        .catch(err=>{return err;}); 
    },
    async buscarOrden(){
      this.entregas = [];
       const result = await axios.get(config.apiAdempiere + "/seguimientopedido/search_orden", 
        {
          headers: { 'token': this.$cookie.get('token') },
          params: this.req_sol
        }).then(res=>{  
          if(res.data.status == "success"){  
            return res.data.data; 
          }
          if(res.data.status == "unauthorized"){  
            return false; 
          }  
        })
        .catch(err=>{return err;});   

        if (result.length == 0) {
          this.alert.typeAlert = "warning";
          this.alert.showAlery = true;
          this.alert.msg = "La orden no tiene entregas, contacta al personal de almácen"; 
        }
        if(result.length > 0){
          this.alert.typeAlert = "success";
          this.alert.showAlery = true;
          this.alert.msg = "Entregas encontradas"; 
          this.entregas = result;
          // console.log(this.orden);
          this.comprobado = true;
        }
        if (result === false) {
          this.alert.typeAlert = "error";
          this.alert.showAlery = true;
          this.alert.msg = "El código de seguridad es incorrecto"; 
        }
    },
    uppercase() {
        this.req_sol.no_orden = this.req_sol.no_orden.toUpperCase();
    },
    validaOrden(){
      if (this.req_sol.no_orden == '' || this.req_sol.no_orden.length < 4) {
        this.solicitacode = false;
      }else{
        this.solicitacode = true;
      }
    },
    formatMXN(value) {
          var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
          return formatter.format(value);
    } 
  },  
}
</script>