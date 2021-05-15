<template>
    <div> 
    <v-container class="grey lighten-5">
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
    </v-container>
    <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
        {{msgError}}
    </v-alert>

    <v-container v-if="!isCrud"> 
        <template> 
            <div class="my-2">
                <v-btn color="primary" @click="refresh()" label="refresh" fab  small  dark ><v-icon>mdi-cached</v-icon></v-btn>
            </div>
            <v-card>
                <v-card-title>
                    <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line hide-details
                    ></v-text-field>
                </v-card-title>
                <v-data-table
                    no-data-text="No hay datos disponibles"
                    no-results-text="No hay coincidencias de tu busqueda."
                    :footer-props="{'items-per-page-options': [20,30,40,50]}"
                    :headers="headers" :items="preRegistros" :search="search">
                    <template v-slot:[`item.actions`]="{ item }">
                        <center>
                            <v-icon color="green darken-2" medium @click="crud(item)">
                                mdi-arrow-up-bold-box-outline
                            </v-icon>
                        </center>
                    </template>
                </v-data-table>
            </v-card>
        </template>
    </v-container> 

    <v-container v-if="isCrud">  
        <v-btn  icon color="blue" @click="isCrud = false"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
        <form class="my-8"> 
            <v-chip  class="ma-2" color="primary" outlined pill>
                <v-icon left>mdi-label</v-icon>
                <span>Folio:</span>
                <strong>{{solicitud.folio}}</strong>&nbsp; 
            </v-chip> 
            <v-select class="my-5" v-model="solicitud.tipoSolicitante.tipo" :items="tiposSolicitantes" 
                :error-messages="error.tipoSolicitante.tipo" label="*Tipo de Solicitante" required>
            </v-select>
            <div v-if="solicitud.tipoSolicitante.tipo=='Recomendado por Familiar/Amigo'">
                <v-row>
                    <v-col>
                        <v-text-field name="personaReferencia" id="personaReferencia" v-model="solicitud.tipoSolicitante.personaReferencia" 
                            :error-messages="error.tipoSolicitante.personaReferencia" label="Nombre de la persona que es la referencia.">
                        </v-text-field>
                    </v-col>
                    <v-col>
                        <v-text-field name="celularReferencia" id="celularReferencia" v-model="solicitud.tipoSolicitante.celularReferencia" type="number"
                            :error-messages="error.tipoSolicitante.celularReferencia" :counter="10" 
                            label="Número de contato de la referencia" onkeydown="javascript: return event.keyCode == 69 ? false : true">
                        </v-text-field>
                    </v-col>
                    <v-col>
                        <v-text-field name="parentezcoReferencia" id="parentezcoReferencia" v-model="solicitud.tipoSolicitante.parentezcoReferencia"
                            :error-messages="error.tipoSolicitante.parentezcoReferencia" label="Parentezco">
                        </v-text-field>
                    </v-col>
                </v-row> 
            </div>  
            <div v-if="solicitud.tipoSolicitante.tipo=='Distribuidor'">
                <v-row>
                    <v-col>
                        <v-text-field name="razonSocial" id="razonSocial" v-model="solicitud.tipoSolicitante.razonSocial" 
                            :error-messages="error.tipoSolicitante.razonSocial" label="Razón social">
                        </v-text-field>
                    </v-col> 
                </v-row> 
            </div>  
            <v-text-field v-model="solicitud.nombreSolicitante" :error-messages="error.nombreSolicitante" :counter="100" 
                label="*Nombre Completo" name="nombre" id="nombre" required @input="validaNombre()"  @blur="validaNombre()" >
            </v-text-field> 
            <v-row>
                <v-col>
                    <v-text-field name="celular" id="celular" type="number"  v-model="solicitud.numeroCelular" :error-messages="error.numeroCelular"  
                        label="*Número Celular" required @input="validaCelular()" @blur="validaCelular()" :counter="10"
                        onkeydown="javascript: return event.keyCode == 69 ? false : true" style="width:500px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-text-field name="email" id="email" v-model="solicitud.email" :error-messages="error.email"  label="*E-mail" required
                        @input="validaEmail()" @blur="validaEmail()" style="width:500px" >
                    </v-text-field>
                </v-col>
            </v-row>  
            <v-divider class="my-10"></v-divider>
            <v-row>
                <v-col>
                    <v-checkbox v-model="solicitud.requiredFactura" label="¿Requiere Facturación?">
                    </v-checkbox>
                </v-col>
                <v-col>
                    <v-text-field name="rfc" id="rfc" v-model="solicitud.tipoSolicitante.rfcColborador" 
                        :error-messages="error.tipoSolicitante.rfcColborador" :counter="13" label="RFC"
                        style="width:400px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-select v-model="solicitud.UsoCFDI" :items="usosCFDI" label="Uso de CFDI" item-text="name"
                        item-value="value" :error-messages="error.UsoCFDI"  style="width:500px"
                    ></v-select> 
                </v-col> 
            </v-row>  

           
            <v-row>
                <v-col>
                    <!-- <v-btn @click="validarCp()">valida CP</v-btn> -->
                    <v-text-field name="cp" id="cp" @change="validarCp()" @input="validarCp()"
                        v-model="solicitud.cp" :error-messages="error.cp"
                        onkeydown="javascript: return event.keyCode == 69 ? false : true"
                        type="number" :counter="5" label="C.P">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-text-field name="pais" id="pais" v-model="solicitud.pais" 
                        :error-messages="error.pais"  label="pais" disabled
                        style="width:400px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-text-field name="estado" id="estado" v-model="solicitud.estado" 
                        :error-messages="error.estado"  label="Estado" disabled
                        style="width:400px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-text-field name="municipio" id="municipio" v-model="solicitud.municipio" 
                        :error-messages="error.municipio"  label="Municipio" disabled
                        style="width:400px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-text-field name="ciudad" id="ciudad" v-model="solicitud.ciudad" 
                        :error-messages="error.ciudad"  label="Ciudad" disabled
                        style="width:400px">
                    </v-text-field>
                </v-col>
                <v-col>
                    <v-select
                        v-model="solicitud.asentamiento" :items="asentamientos"
                        label="Asentamiento" item-text="asentamiento"
                        item-value="asentamiento"
                        no-data-text="No hay datos disponibles"
                        :error-messages="error.asentamiento"
                        style="width:400px"
                    ></v-select> 
                </v-col>
                <v-col>
                    <v-text-field name="direccion" id="direccion"
                         v-model="solicitud.direccion" 
                         :error-messages="error.direccion" 
                         style="width:400px"
                         label="Calle y Número">
                    </v-text-field> 
                </v-col>
            </v-row> 


            <div class="my-10">
                <v-btn class="ma-2" color="primary" @click="registrar()">
                    <v-icon left dark>mdi-checkbox-marked-circle</v-icon>
                    Aprovar Solicitud
                </v-btn> 
                <v-btn class="ma-2" color="error" @click="registrar()">
                    <v-icon left dark>mdi-cancel</v-icon>
                    Rechazar Solicitud
                </v-btn>
            </div> 
        </form>
    </v-container>  
    </div>
</template>

<script>
import { validationMixin } from 'vuelidate'
import { required, maxLength, email,minLength } from 'vuelidate/lib/validators'
import axios from 'axios'; 
import config from '../../json/config.json';  

export default {
    mixins: [validationMixin],
    validations: {
        name: { required, maxLength: maxLength(100),minLength: minLength(10) },
        rfc: { required, maxLength: maxLength(13),minLength: minLength(13) },
        celular : { required, maxLength: maxLength(15),minLength: minLength(10)},
        email: { required, email },
        select: { required }, 
    },
    data: () => ({ 
        preRegistros:[],
        search: '',
        headers: [
          { text: 'Folio', value: 'folio' },
          {
            text: 'Nombre',
            align: 'start',
            // filterable: false,
            value: 'nombreSolicitante',
          },
          { text: 'Celular', value: 'numeroCelular' },
          { text: 'Tipo', value: "tipoSolicitante.tipo" },
          { text: 'RFC', value: 'tipoSolicitante.rfcColborador' },
          { text: 'E-mail', value: 'email' },
          { text: 'Actions', value: 'actions', sortable: false },
        ],
        snackbar : true,
        msgError:'',
        isCrud:false,
        usosCFDI:[], 
        asentamientos:[], 
        solicitud: {
            cp:"",
            estado:"",
            ciudad:"",
            municipio:"",
            pais:"",
            asentamiento : "",
            folio:"No creado",
            tipoSolicitante:{
                tipo:"",
                razonSocial:"",
                personaReferencia:"",
                celularReferencia:"",
                parentezcoReferencia:"",
                rfcColborador:""
            },
            nombreSolicitante:"",
            numeroCelular:"",
            email:"",
            requiredFactura:false, 
            direccion:"",
            UsoCFDI:"", 
        }, 
        error: {
            cp:"",
            estado:"",
            ciudad:"",
            municipio:"",
            pais:"",
            asentamiento : "",
            tipoSolicitante:{
                tipo:"",
                razonSocial:"",
                personaReferencia:"",
                celularReferencia:"",
                parentezcoReferencia:"",
                rfcColborador:""
            },
            nombreSolicitante:"",
            numeroCelular:"",
            email:"",
            requiredFactura:false,
            direccion:"",
            terminosError:"", 
            UsoCFDI:""
        },
        isLoad:false,
        tiposSolicitantes: [
            'Distribuidor',
            'Recomendado por Familiar/Amigo',
            'Colaborador Refividrio',
        ],
        tipoSolicitanteValido : false,
        terminos: false,
        dialog : false
    }),components: { 
    },
    async created(){ 
       this.getCollections();
    },
    computed: {},
    methods: {
        async getCollections(){
            this.isLoad = true;
            this.preRegistros = await axios.get(config.apiAdempiere + "/preregistro/getByFilter",
            { headers:{token: this.$cookie.get('token')}, data:{filer: {}}})
            .then(res=>{return res.data;})
            .catch(err=>{return err;});  
            if (this.preRegistros.status == "success") {
                this.preRegistros = this.preRegistros.data;
                for (let index = 0; index < this.preRegistros.length; index++) {
                    this.preRegistros[index].tipoSolicitante = this.preRegistros[index].tipoSolicitante[0];
                }
            }else
                this.preRegistros = []; 
            
            this.usosCFDI = await axios.get(config.apiAdempiere + "/preregistro/get_uso_cfdi",{})
            .then(res=>{return res.data;})
            .catch(err=>{return err;});
            this.usosCFDI.status == "success"?this.usosCFDI = this.usosCFDI.data:this.usosCFDI = [];
            this.isLoad = false;
        },
        refresh(){
            this.getCollections();
        },
        crud(item){
            this.isCrud = true;
            this.solicitud = item;
            console.log(JSON.stringify(this.solicitud));
            this.asentamientos = []; 
            if (this.solicitud.asentamiento != "" && this.solicitud.asentamiento != undefined) {
                this.asentamientos.push({"asentamiento":this.solicitud.asentamiento});
            } 
        },
        approved(item){
            console.log(item);
        },reject(item){
            console.log(item);
        },async validarCp(){
            this.asentamientos = [];
            this.solicitud.estado = "";
            this.solicitud.ciudad = "";
            this.solicitud.municipio = "";
            this.solicitud.pais = "";
            if (this.solicitud.cp != "" && this.solicitud.cp.length==5) { 
                this.isLoad = true;
                let uriCp = `https://api-sepomex.hckdrk.mx/query/info_cp/${this.solicitud.cp}?token=3bda8a59-91e8-4b44-a534-1761a6e60335`;
                await axios.get(uriCp)
                .then(res=>{
                    try {
                        this.solicitud.estado = res.data[0].response.estado;
                        this.solicitud.ciudad = res.data[0].response.ciudad;
                        this.solicitud.municipio = res.data[0].response.municipio;
                        this.solicitud.pais = res.data[0].response.pais;
                        for (let index = 0; index < res.data.length; index++) {
                            const element = res.data[index];
                            this.asentamientos.push(element.response);
                        } 
                        document.getElementById("cp").blur();
                    } catch (error) {
                        document.getElementById("cp").blur();
                        this.msgError = "Existe un error con tu Código Postal.";
                        console.log(error);
                    } 
                }).catch(err=>{
                    document.getElementById("cp").blur();
                    console.log(err);
                    this.msgError = "El Código Postal ingresado es Inválido.";
                    window.scrollTo(0,0);
                });
                this.isLoad = false;
            }
        },   
        validaNombre(){ 
            if (this.solicitud.nombreSolicitante != "" && this.solicitud.nombreSolicitante.length > 10) {
                this.error.nombreSolicitante = "";
                return true;
            }else{
                this.error.nombreSolicitante = "Nombre Requerido";
                return false;
            } 
        },
        validaCelular(){
            if(this.solicitud.numeroCelular == "" || this.solicitud.numeroCelular.length != 10){
                this.error.numeroCelular = "Celular Requerido, 10 digitos";
                return false;
            }else{
                this.error.numeroCelular = "";
                return true;
            } 
        },
        validaEmail(){
            var regOficial =/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/ ;
            if(regOficial.test(this.solicitud.email)){
                this.error.email = "";
                return true;
            }else{
                this.error.email = "Email Requerido";
                return false;
            } 
        },
        validaTipoSolicitante(){
            let valido=true;
            switch (this.solicitud.tipoSolicitante.tipo) {
                case 'Distribuidor':
                    if (this.solicitud.tipoSolicitante.razonSocial != "" && this.solicitud.tipoSolicitante.razonSocial.trim().length > 5) {
                        this.error.tipoSolicitante.razonSocial="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.razonSocial="Es necesario que ingreses tu Razón Social.";
                    }
                    break;
                case 'Recomendado por Familiar/Amigo':
                    if (this.solicitud.tipoSolicitante.personaReferencia != "" && this.solicitud.tipoSolicitante.personaReferencia.trim().length > 5) {
                        this.error.tipoSolicitante.personaReferencia="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.personaReferencia="Es necesario que ingreses a tu referencia.";
                    }

                    if (this.solicitud.tipoSolicitante.celularReferencia != "" && this.solicitud.tipoSolicitante.celularReferencia.trim().length == 10) {
                        this.error.tipoSolicitante.celularReferencia="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.celularReferencia="Es necesario que ingreses el Celular de tu referencia.";
                    }

                    if (this.solicitud.tipoSolicitante.parentezcoReferencia != "" && this.solicitud.tipoSolicitante.parentezcoReferencia.trim().length > 2) {
                        this.error.tipoSolicitante.parentezcoReferencia="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.parentezcoReferencia="Es necesario que ingreses tu Parentezco.";
                    }
                    break;
                case 'Colaborador Refividrio':
                    if (this.solicitud.tipoSolicitante.rfcColborador != "" && this.solicitud.tipoSolicitante.rfcColborador.trim().length == 13) {
                        this.error.tipoSolicitante.rfcColborador="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.rfcColborador="Es necesario que ingreses tu RFC.";
                    }
                    break;
                default:
                    break;
            } 
            if (valido) {
              this.tipoSolicitanteValido = true;   
            }
        },
        async registrar() {
            this.msgError = "";
            let valido = true;   
            if (this.solicitud.requiredFactura) {
                if (this.solicitud.tipoSolicitante.rfcColborador == "" || this.solicitud.tipoSolicitante.rfcColborador.length < 13) {
                    this.error.tipoSolicitante.rfcColborador = "Para la facturación debé ser válido tu RFC";
                    valido = false;
                } else {
                    this.error.tipoSolicitante.rfcColborador = "";
                }
                if (this.solicitud.direccion == "" || this.solicitud.direccion.length < 10) {
                    this.error.direccion = "Para la facturación tu dirección debé ser válida";
                    valido = false;
                } else {
                    this.error.direccion = "";
                }
                if (this.solicitud.UsoCFDI == "" || this.solicitud.UsoCFDI.length < 2) {
                    this.error.UsoCFDI = "Para la facturación el uso de CFDI debé ser válido";
                    valido = false;
                } else {
                    this.error.UsoCFDI = "";
                }
            }else{
                this.error.tipoSolicitante.rfcColborador = "";
                this.error.direccion = "";
                this.error.UsoCFDI = "";
            }
            if (!this.validaNombre()) {
                valido = false;
            }
            if (!this.validaCelular()) {
                valido = false;
            }
            if (!this.validaEmail()) {
                valido = false;
            }  
            if (valido) {
                console.log(JSON.stringify(this.solicitud));
                this.isLoad = true;
                // const result = await axios.post(config.apiAdempiere + "/preregistro/add_pre",this.solicitud
                // ,{headers:{}})
                // .then(res=>{  
                //     return res.data;
                // }).catch(err=>{
                //     console.log(err); 
                //     return false;
                // });
                let result = false;
                if (result!=false) { 
                    if (result.status == "success") {
                        this.solicitud = result.data;
                        this.isRegistrado = true;
                    } else {
                        try { 
                            if (result.data.code == "11000" ) {
                                console.log(result.data.keyValue);
                                console.log(result.data.keyValue.numeroCelular);
                                console.log(result.data.keyValue['tipoSolicitante.rfcColborador']);
                                console.log(result.data.keyValue.email);
                                if (result.data.keyValue.numeroCelular != undefined) {
                                    this.msgError = "Parece que ya hay una solicitud con este Número Celular, por favor verificalo."; 
                                }
                                if (result.data.keyValue['tipoSolicitante.rfcColborador'] != undefined) {
                                    this.msgError = "Parece que ya hay una solicitud con este RFC de solicitante, por favor verificalo."; 
                                }
                                if (result.data.keyValue.email != undefined) {
                                    this.msgError = "Parece que ya hay una solicitud con este Email de solicitante, por favor verificalo."; 
                                }
                            }else{
                                this.msgError = result.data; 
                            } 
                        } catch (error) {
                            console.log(error);
                            this.msgError = "Existe un error desconocido, intentalo más tarde.";
                        } 
                    }
                }else{
                    this.msgError = "Existe un error, Intentalo más tarde."; 
                }
                window.scrollTo(0,0);
                this.isLoad = false; 
            }else{
               console.log("Ingresa Todos los Datos"); 
            } 
        },
        formatDate(dates) {
            if (dates === undefined)return "Error de Fecha" 
            try {
                 var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
                return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()-1]} del ${(new Date(Date.parse(dates))).getFullYear()}`
            } catch (error) {
                console.log(error);
                return "Error de Fecha";
            } 
        }, 
    },
  }
</script>

<style lang="scss">
    input[type=number]::-webkit-inner-spin-button, 
    input[type=number]::-webkit-outer-spin-button { 
    -webkit-appearance: none; 
    margin: 0; 
    }

    input[type=number] { -moz-appearance:textfield; }
</style>

 