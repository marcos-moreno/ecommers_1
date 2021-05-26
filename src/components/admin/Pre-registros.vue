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
 
    <v-container> 
        <v-btn  v-if="isCrud" icon color="blue" @click="returnTable()"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
        <v-divider class="my-2"></v-divider>
        <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
            {{msgError}}
        </v-alert>
    </v-container> 

    <v-container v-if="!isCrud"> 
        <template> 
            <div> 
                <v-row>
                    <v-col>
                        <v-btn color="primary" @click="refresh()" label="refresh" fab  small  dark ><v-icon>mdi-cached</v-icon></v-btn>
                    </v-col>
                    <v-col>
                        <v-select class="my-5" v-model="filterStatus" :items="statusSolicitud" item-text="nombre"
                            :error-messages="error.filterStatus" label="Estatus de solicitud" item-value="code"
                            @change="filtrarRegistros()" >
                        </v-select>
                    </v-col>
                </v-row> 
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
                    :headers="headers" :items="preRegistrosFiltrado" :search="search">
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
        <form >   
            <v-alert v-if="solicitud.resultAD!= undefined && solicitud.resultAD !={}" 
                border="top" colored-border type="info" elevation="2">
                <div> 
                    <!-- {{solicitud.resultAD.data.msg}} -->
                    {{valorEstadoSolicitud}}  
                </div>
            </v-alert> 

            <v-chip  class="ma-2" color="primary" outlined pill>
                <v-icon left>mdi-label</v-icon>
                <span>Folio:</span>
                <strong>{{solicitud.folio}}</strong>&nbsp; 
            </v-chip>   

            <v-chip v-if="solicitud.c_bpartner_id!=undefined" class="ma-2" color="primary"  text-color="white">
                <v-icon left>
                   mdi-star
                </v-icon>
                ID SOCIO: {{solicitud.c_bpartner_id}} 
            </v-chip> 

            <v-chip v-if="solicitud.ad_user_id!=undefined" class="ma-2" color="primary"  text-color="white">
                <v-icon left>
                   mdi-star
                </v-icon>
               ID USUARIO: {{solicitud.ad_user_id}} 
            </v-chip>

            <v-chip v-if="solicitud.c_bpartner_id!=undefined" class="ma-2" color="primary"  text-color="white">
                <v-icon left>
                   mdi-star
                </v-icon>
                Solicitud: {{formatDate(solicitud.created_at)}} a las {{formatTime(solicitud.created_at)}}
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
                    <v-text-field name="email" id="email" v-model="solicitud.email" :error-messages="error.email"  label="*Correo Electrónico" required
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
                        :error-messages="error.pais"  label="País" disabled
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
            <v-row>
                <v-col>
                    <v-text-field name="montPreAprobed" id="montPreAprobed" 
                        @blur="formatMoney"  
                        v-model="solicitud.montPreAprobed" :error-messages="error.montPreAprobed"
                        onkeydown="javascript: return (event.key == '$'||event.key == ','||event.key == 'ArrowRight'||event.key == 'ArrowLeft'||event.key == '.'||event.key == 'Backspace'||event.key < 48 || event.key > 57) ? true : false"
                        type="text" label="Monto PRE-APROBADO" style="width:400px">
                    </v-text-field>
                </v-col> 
                <!-- <v-col>
                    <v-text-field name="password" id="password"
                         v-model="solicitud.direccion" 
                         :error-messages="error.direccion" 
                         style="width:400px"
                         label="Password">
                    </v-text-field> 
                </v-col> -->
            </v-row> 

            <div class="my-10">
                <v-btn class="ma-2" color="primary" @click="approved()">
                    <v-icon left dark>mdi-checkbox-marked-circle</v-icon>
                    Aprobar Solicitud
                </v-btn> 
                <v-btn class="ma-2" color="error" @click="reject()">
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
const validateRfc = require('validate-rfc');

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
        filterStatus:'PA',
        statusSolicitud:[
            {nombre:'Todo',code:'all'},
            {nombre:'Pendiente de Autorizar',code:'PA'},
            {nombre:'Socio Autorizado',code:'AU'},
            {nombre:'Empleado No Registrado en AD',code:'ARH'},
            {nombre:'Más de un registro (Socio o Usuario)',code:'SD'},
            {nombre:'Socio de Negocio Existente',code:'SE'},
        ],
        preRegistros:[],
        preRegistrosFiltrado:[],
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
          { text: 'Estado', value: 'estado_solicitud' },
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
                montPreAprobed:0,
                ApprovedCredit:false
            }, 
        error: {
            cp:"",
            estado:"",
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
            UsoCFDI:""
        },
        isLoad:false,
        tiposSolicitantes: [
            'Distribuidor',
            'Recomendado por Familiar/Amigo',
            'Colaborador Refividrio',
        ],
        tipoSolicitanteValido : false, 
        dialog : false
    }),components: { 
    },
    async created(){ 
       await this.validaLogin();
       await this.getCollections();
       this.filtrarRegistros();
    },
    computed: {
        valorEstadoSolicitud: function (){
            switch (this.solicitud.estado_solicitud) {
                case "SE":
                    return "El socio de Negocio ya existe.";
                case "SD":
                    return "El RFC corresponde a más de un Usuario.";
                case "ARH":
                    return "En espera de alta del empleado.";
                case "AU":
                    return "Registro Completo.";
                default:
                    return "No hay proceso";
            }
            
        }
    },
    methods: {
        filtrarRegistros(){
            if (this.filterStatus == 'all') {
                this.preRegistrosFiltrado = this.preRegistros;
                return; 
            }
            this.preRegistrosFiltrado = [];
            for (let index = 0; index < this.preRegistros.length; index++) {
                const element = this.preRegistros[index];
                if (element.estado_solicitud == this.filterStatus) {
                    this.preRegistrosFiltrado.push(element);
                }
            } 
        },
        keyhander: function(event) {
            console.log(event);
            if (event.key == "+")
            { 
                event.preventDefault();
            }
        },
        formatMXN(value) {
            var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
            return formatter.format(value);
        },
        formatMoney(){ 
            let i = 0;
            while(isNaN(this.solicitud.montPreAprobed)||i==20) {
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace('$', '');
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace(',', '');
                i++;
            }
            this.solicitud.montPreAprobed = this.formatMXN(this.solicitud.montPreAprobed);
        },
        returnTable(){
            this.isCrud = false;
            this.msgError = "";
        },
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
        async refresh(){
            await this.getCollections();
            this.filtrarRegistros();
        },
        async crud(item){
            this.msgError = "";
            this.isCrud = true;
            this.solicitud = item; 
            this.asentamientos = []; 
            this.formatMoney(); 
            if (this.solicitud.asentamiento != "" && this.solicitud.asentamiento != undefined) {
                this.asentamientos.push({"asentamiento":this.solicitud.asentamiento});
            }
        },
        async approved(){
             this.msgError = "";
            let valido = true; 
            
            if(!this.validaDireccion())
                valido = false;  
            if (!this.validaNombre()) {
                valido = false;
            }
            if (!this.validaCelular()) {
                valido = false;
            } 
            if (!this.validaEmail()) {
                valido = false;
            } 
            if (!this.validaRFC()) {
                 valido = false;
            }
            if (!await this.validarCp()) {
                 valido = false;
            }   
            let i = 0;
            while(isNaN(this.solicitud.montPreAprobed)||i==20) {
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace('$', '');
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace(',', '');
                i++;
            }
            this.solicitud.ApprovedCredit = false;
            if (parseInt(this.solicitud.montPreAprobed) > 0) {
                this.solicitud.ApprovedCredit = true;
            }
            console.log(this.solicitud);
            // valido = false;
            if (valido) {
                this.isLoad = true;  
                const result = await axios.post(config.apiAdempiere + "/preregistro/insercbpartner",this.solicitud
                ,{headers:{ 'token': this.$cookie.get('token') }})
                .then(res=>{  
                    console.log(res);
                    return res.data;
                }).catch(err=>{
                    console.log(err); 
                    return false;
                });
                console.log(result);
                if (result.status == "success") {
                    this.solicitud = result.data;
                    this.solicitud.tipoSolicitante = this.solicitud.tipoSolicitante[0];
                } else {
                    this.msgError = result.data;
                }
                if (result!=false) { 
                    if (result.status == "success") {
                        this.solicitud = result.data;
                        this.isRegistrado = true;
                    } else {
                        console.log(result);
                        try {
                            if (result.data == "rfcDuplicado") {
                                this.msgError = "Parece que ya hay una solicitud con este RFC de solicitante, por favor verificalo."; 
                                this.isLoad = false;
                                window.scrollTo(0,0);
                                return;
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
               if (this.msgError == "") {
                   this.msgError = "Completa todos los datos";
               }
               window.scrollTo(0,0);
            } 
        },reject(item){
            console.log(item);
        },async validarCp(){
         this.msgError = "";
            this.asentamientos = [];
            this.solicitud.estado = "";
            this.solicitud.ciudad = "";
            this.solicitud.municipio = "";
            this.solicitud.pais = "";
            this.error.cp = "";
            
            if (this.solicitud.cp != "") {
                if (this.solicitud.cp.length!=5){
                    this.error.cp = "El Código Postal ingresado es Inválido.";
                    return false;
                }
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
                        this.error.cp = "Existe un error con este Código Postal.";
                        console.log(error);
                    } 
                }).catch(err=>{ 
                    console.log(err);
                    document.getElementById("cp").blur(); 
                    this.msgError = "El Código Postal ingresado es Inválido.";
                    this.error.cp = "El Código Postal ingresado es Inválido.";
                    window.scrollTo(0,0);
                });  
                this.isLoad = false;
                return true; 
            }else{
                if (this.solicitud.requiredFactura) {
                    this.error.cp = "Para la facturación es necesario El Código Postal";
                    return false;
                }else{
                    return true;
                } 
            }
        },validaDireccion(){
            let valido = true;
            if (this.solicitud.requiredFactura) {  
                if (this.solicitud.direccion == "" || this.solicitud.direccion.length < 10) {
                    this.error.direccion = "Para la facturación tu Calle y Número debén ser válidos";
                    valido = false;
                } else {
                    this.error.direccion = "";
                }
                if (this.solicitud.cp == "" || this.solicitud.cp.length != 5) {
                    this.error.cp = "Para la facturación tu C.P. debé ser válido";
                    valido = false;
                } else {
                    this.error.cp = "";
                }  
                if (this.solicitud.asentamiento == "" || this.solicitud.asentamiento.length < 5) {
                    this.error.asentamiento = "Para la facturación tu Colonia debé ser válido";
                    valido = false;
                } else {
                    this.error.asentamiento = "";
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
                this.error.asentamiento = "";
                this.error.cp = "";
            } 
            return valido;
        },  
        validaRFC(){  
            if (this.solicitud.tipoSolicitante.tipo == "Colaborador Refividrio") { 
                const rfcRespuesta = validateRfc(this.solicitud.tipoSolicitante.rfcColborador.trim());
                if(rfcRespuesta.isValid)
                {
                   if(rfcRespuesta.type == "person")
                    {
                        this.error.tipoSolicitante.rfcColborador="";
                        this.solicitud.tipoSolicitante.rfcColborador = rfcRespuesta.rfc;
                        return true;
                    }else{
                        this.error.tipoSolicitante.rfcColborador='Tu RFC debé ser de tipo "Persona Física"';
                        return false;
                    } 
                }else{
                    this.error.tipoSolicitante.rfcColborador="Es necesario que ingreses un RFC válido.";
                    return false;
                } 
            } 
            if (this.solicitud.tipoSolicitante.requiredFactura) { 
                const rfcRespuesta = validateRfc(this.solicitud.tipoSolicitante.rfcColborador.trim());
                if(rfcRespuesta.isValid)
                {
                    this.error.tipoSolicitante.rfcColborador="";
                    this.solicitud.tipoSolicitante.rfcColborador = rfcRespuesta.rfc;
                    return true;
                }else{
                    this.error.tipoSolicitante.rfcColborador="Es necesario que ingreses un RFC válido.";
                    return false;
                }
            } else {
                if (this.solicitud.tipoSolicitante.rfcColborador != "") {
                    const rfcRespuesta = validateRfc(this.solicitud.tipoSolicitante.rfcColborador.trim());
                    if(rfcRespuesta.isValid)
                    {
                        this.error.tipoSolicitante.rfcColborador="";
                        this.solicitud.tipoSolicitante.rfcColborador = rfcRespuesta.rfc;
                        return true;
                    }else{
                        this.error.tipoSolicitante.rfcColborador="Es necesario que ingreses un RFC válido o dejes el campo vacío.";
                        return false;
                    }
                }
                 
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
            this.solicitud.numeroCelular = this.solicitud.numeroCelular.replace(".","").replace(",","");
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
                this.error.email = "Correo Electrónico Requerido";
                return false;
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
        formatTime(dates) { 
        const hours = ('0' + (new Date(Date.parse(dates))).getHours()).slice(-2)
        const minutes = ('0' + (new Date(Date.parse(dates))).getMinutes()).slice(-2)
        return `${hours}:${minutes} hrs.`
        },
        async validaLogin(){
            this.user = await axios.get(config.apiAdempiere + "/user/userByTokenAdmin", 
            {
                'headers': { 'token': this.$cookie.get('token') }
            }).then(res=>{return res.data;})
            .catch(err=>{return err;});
            if(this.user.status == "unauthorized"){ 
               this.$router.push('/shop/admin'+config.matchAdmin+'/login');      
            } 
        }
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

 