<template>
    <div>
    <app-menu/> 
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
            <v-dialog v-model="dialog" width="500"> 
                <v-card>
                    <v-card-title class="headline grey lighten-2">
                        Terminos y condiciones
                    </v-card-title> 
                    <v-card-text>
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    </v-card-text>
                    <v-divider></v-divider>
                    <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialog = false">
                        Cerrar
                    </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>  
        </div>
        <v-alert v-if="!isRegistrado" text dense color="teal" class="my-2" icon="mdi-clock-fast" border="left">
            Completa tu Pre-registro, esta sujeto a una aprovación por parte de Refividrio.
        </v-alert>
        <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
            {{msgError}}
        </v-alert>
        <div v-if="!isRegistrado">
            <v-container v-if="solicitud.tipoSolicitante.tipo != '' && tipoSolicitanteValido">  
                <v-btn icon color="blue" @click="tipoSolicitanteValido = false"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
                <form class="my-5">
                    <v-text-field v-model="solicitud.nombreSolicitante" :error-messages="error.nombreSolicitante" :counter="100" 
                        label="*Nombre Completo" name="nombre" id="nombre" required @input="validaNombre()"  @blur="validaNombre()" >
                    </v-text-field>
                    
                    <v-row>
                        <v-col>
                            <v-text-field name="celular" id="celular" type="number"  v-model="solicitud.numeroCelular" :error-messages="error.numeroCelular"  
                                label="*Número Celular" required @input="validaCelular()" @blur="validaCelular()" :counter="10"
                                onkeydown="javascript: return event.keyCode == 69 ? false : true"
                                style="width:500px"
                            >
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
                            <v-checkbox v-model="solicitud.requiredFactura"
                                label="¿Requiere Facturación?">
                            </v-checkbox>
                        </v-col>
                        <v-col>
                            <v-text-field name="rfc" id="rfc" v-model="solicitud.tipoSolicitante.rfcColborador" 
                                :error-messages="error.tipoSolicitante.rfcColborador" :counter="13" label="RFC"
                                style="width:400px"
                            >
                            </v-text-field>
                        </v-col>
                        <v-col>
                            <v-select
                                v-model="solicitud.UsoCFDI" :items="usosCFDI"
                                label="Uso de CFDI" item-text="name"
                                item-value="value"
                                :error-messages="error.UsoCFDI" 
                                style="width:400px"
                            ></v-select> 
                        </v-col> 
                    </v-row>  

                    <v-row>
                        <v-col>
                           <!-- <v-btn @click="validarCp()">valida CP</v-btn> -->
                            <v-text-field name="cp" id="cp" @change="validarCp()" @input="validarCp()"
                                v-model="solicitud.cp" :error-messages="error.cp"
                                onkeydown="javascript: return event.keyCode == 69 ? false : true"
                                style="width:400px"
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
                                @change="validaDireccion()"
                                v-model="solicitud.asentamiento" :items="asentamientos"
                                label="Asentamiento" item-text="asentamiento"
                                item-value="asentamiento"
                                no-data-text="No hay datos disponibles"
                                :error-messages="error.asentamiento"
                                style="width:400px"
                            ></v-select> 
                        </v-col> 
                        <v-col>
                            <v-text-field
                                @change="validaDireccion()" @input="validaDireccion()"
                                name="direccion" id="direccion"
                                v-model="solicitud.direccion" 
                                :error-messages="error.direccion" 
                                style="width:400px"
                                label="Calle y Número">
                            </v-text-field> 
                        </v-col>
                    </v-row> 

                     

                 

                    <v-divider class="my-10"></v-divider>
                    <v-checkbox @change="validaTerminos()" v-model="terminos" :error-messages="error.terminosError" 
                        label="*Acepto los terminos y condiciones" required>
                    </v-checkbox>
                    <a href="#" @click="dialog=true" >Leer terminos y condiciones</a>
                    <br>
                    <v-btn class="my-10 mr-4" @click="registrar()">Registrar</v-btn> 
                </form>
            </v-container>

            <v-container  class="my-10" v-else style="min-height:500px" > 
                <v-select v-model="solicitud.tipoSolicitante.tipo" :items="tiposSolicitantes" @change="changeTipoSolicitante()"
                    :error-messages="error.tipoSolicitante.tipo" label="*Tipo de Solicitante" required>
                </v-select>
                <div v-if="solicitud.tipoSolicitante.tipo=='Recomendado por Familiar/Amigo'">
                    <v-row>
                        <v-col>
                            <v-text-field name="personaReferencia" id="personaReferencia" v-model="solicitud.tipoSolicitante.personaReferencia" 
                                :error-messages="error.tipoSolicitante.personaReferencia" 
                                label="Nombre de tu referencia." style="width:400px"
                                @input="validaTipoSolicitante()"
                                >
                            </v-text-field>
                        </v-col>
                        <v-col>
                            <v-text-field name="celularReferencia" id="celularReferencia" v-model="solicitud.tipoSolicitante.celularReferencia" type="number"
                                :error-messages="error.tipoSolicitante.celularReferencia" :counter="10" 
                                style="width:400px"
                                label="Número de contato de la referencia" 
                                 @input="validaTipoSolicitante()"
                                onkeydown="javascript: return event.keyCode == 69 ? false : true">
                            </v-text-field>
                        </v-col>
                        <v-col>
                            <v-text-field name="parentezcoReferencia" id="parentezcoReferencia" 
                                v-model="solicitud.tipoSolicitante.parentezcoReferencia"
                                :error-messages="error.tipoSolicitante.parentezcoReferencia" 
                                @input="validaTipoSolicitante()"
                                label="Parentezco"
                                style="width:400px">
                            </v-text-field>
                        </v-col>
                    </v-row> 
                </div> 
                <div v-if="solicitud.tipoSolicitante.tipo=='Colaborador Refividrio'">
                    <v-row>
                        <v-col>
                            <v-text-field name="rfc" id="rfc"  v-model="solicitud.tipoSolicitante.rfcColborador" 
                                :error-messages="error.tipoSolicitante.rfcColborador" :counter="13"
                                label="RFC del Colaborador"
                                @input="validaTipoSolicitante()">
                            </v-text-field>
                        </v-col> 
                    </v-row> 
                </div>
                <div v-if="solicitud.tipoSolicitante.tipo=='Distribuidor'">
                    <v-row>
                        <v-col>
                            <v-text-field name="razonSocial" id="razonSocial" 
                                v-model="solicitud.tipoSolicitante.razonSocial" 
                                @input="validaTipoSolicitante()"
                                :error-messages="error.tipoSolicitante.razonSocial" label="Razón social">
                            </v-text-field>
                        </v-col> 
                    </v-row> 
                </div> 
                <v-btn class="my-10 mr-4" small color="primary" dark  @click="nextTipoSolicitante()">Continuar</v-btn>
            </v-container>
        </div>
        <v-container v-else style="min-height:500px" > 
            <v-alert type="success" text class="my-10"  border="left">
                Tu Pre-registro esta listo, nosotros te informaremos sobre el estatus de tu solicitud 
                en un périodo máximo de 2 días habiles.
                <br> TU FOLIO DE SOLICITUD: {{solicitud.folio}}
            </v-alert> 
            <v-simple-table>
                <template v-slot:default> 
                <tbody>
                    <tr><td>Folio : {{solicitud.folio}}</td></tr>
                    <tr><td>RFC : {{ solicitud.tipoSolicitante[0].rfcColborador}}</td></tr>
                    <tr><td>Referencia : {{solicitud.tipoSolicitante[0].personaReferencia}}</td></tr>  
                    <tr><td>Contacto de la Referencia : {{solicitud.tipoSolicitante[0].celularReferencia}}</td></tr> 
                    <tr><td>Parentezco : {{solicitud.tipoSolicitante[0].parentezcoReferencia}}</td></tr> 
                    <tr><td>Solicitante : {{solicitud.nombreSolicitante}}</td></tr>
                    <tr><td>Celular : {{solicitud.numeroCelular}}</td></tr>
                    <tr><td>Email : {{solicitud.email}}</td></tr>
                    <tr><td>Direccion : {{solicitud.direccion}}</td></tr>
                    <tr><td>Uso de CFDI : {{solicitud.UsoCFDI}}</td></tr> 
                    <tr><td>Tipo de Solicitante : {{solicitud.tipoSolicitante[0].tipo}}</td></tr> 
                    <tr><td>Razon Social : {{solicitud.tipoSolicitante[0].razonSocial}}</td></tr>
                </tbody>
                </template>
            </v-simple-table>
            <div class="my-7">
                Si tu comprobante no se descargo en automático
                <v-btn small text @click="acuse()" color="primary">
                    click aqui para descargar
                </v-btn>
            </div>
        </v-container>

    </v-container>
    </div>
</template>

<script>
import { validationMixin } from 'vuelidate'
import { required, maxLength, email,minLength } from 'vuelidate/lib/validators'
import axios from 'axios'; 
import config from '../json/config.json'; 
import jsPDF from 'jspdf';
import 'jspdf-autotable';
import AppMenu from '../components/Menu.vue'; 

export default {
    mixins: [validationMixin],
    validations: {
        name: { required, maxLength: maxLength(100),minLength: minLength(10) },
        rfc:  { required, maxLength: maxLength(13),minLength: minLength(13) },
        celular : { required, maxLength: maxLength(15),minLength: minLength(10)},
        email:  { required, email },
        select: { required }, 
    },
    data: () => ({ 
        cpValido:false,
        snackbar : true,
        msgError:'',
        isRegistrado:false,
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
        'app-menu': AppMenu, 
    },
    async created(){
        this.resetSolicitud();
        // this.acuse();
        this.usosCFDI = await axios.get(config.apiAdempiere + "/preregistro/get_uso_cfdi",{})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});
        if (this.usosCFDI.status == "success") {
            this.usosCFDI = this.usosCFDI.data;
        }else{
            this.usosCFDI = [];
        }
    },
    computed: {},
    methods: {
        resetSolicitud(){
            this.solicitud.tipoSolicitante = { 
                tipo:this.solicitud.tipoSolicitante.tipo,
                razonSocial:"",
                personaReferencia:"",
                celularReferencia:"",
                parentezcoReferencia:"",
                rfcColborador:"" 
            };
        },
        async validarCp(){
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
                this.validaDireccion();
            }
        },
        changeTipoSolicitante(){
            this.resetSolicitud();
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
                    if (this.solicitud.tipoSolicitante.rfcColborador != "" 
                        && (this.solicitud.tipoSolicitante.rfcColborador.trim().length == 13 
                            ||
                            this.solicitud.tipoSolicitante.rfcColborador.trim().length == 12
                        )) {
                        this.error.tipoSolicitante.rfcColborador="";
                    }else{
                        valido = false;
                        this.error.tipoSolicitante.rfcColborador="Es necesario que ingreses tu RFC 12-13 Digitos.";
                    }
                    break;
                default:
                    break;
            } 
            return valido;
        },nextTipoSolicitante(){ 
            if (this.validaTipoSolicitante()) {
              this.tipoSolicitanteValido = true;   
            }
        },validaTerminos(){
            let valido = true;
            if (this.terminos == false) {
                this.error.terminosError = "Es necesario que aceptes los terminos y licencias.";
                valido =false;
            } else {
                this.error.terminosError = "";
            }
            return valido;
        },
        async registrar() {
            this.msgError = "";
            let valido = true; 
            if(!this.validaTerminos())
                    valido = false; 
            if (this.solicitud.requiredFactura) {
                if(!this.validaDireccion())
                    valido = false; 
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
            if (!this.terminos) {
                valido = false; 
            }  
            if (valido) { 
                this.isLoad = true;
                this.solicitud.estado_solicitud = "PA";
                const result = await axios.post(config.apiAdempiere + "/preregistro/add_pre",this.solicitud
                ,{headers:{}})
                .then(res=>{
                    return res.data;
                }).catch(err=>{
                    console.log(err);
                    return false;
                });
                if (result!=false) { 
                    if (result.status == "success") {
                        this.solicitud = result.data;
                        this.isRegistrado = true;
                        this.acuse();
                    } else { 
                        try {
                            console.log(result.data);
                            if (result.data.code == "11000" ) {
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
        },validaDireccion(){
            let valido = true;
             if (this.solicitud.tipoSolicitante.rfcColborador != "" 
                && (this.solicitud.tipoSolicitante.rfcColborador.trim().length == 13 
                    ||
                    this.solicitud.tipoSolicitante.rfcColborador.trim().length == 12
                )) {
                this.error.tipoSolicitante.rfcColborador="";
            }else{
                valido = false;
                this.error.tipoSolicitante.rfcColborador="Para la facturación debé ser válido tu RFC 12-13 Digitos.";
            } 
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
                this.error.asentamiento = "Para la facturación tu Asentamiento debé ser válido";
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
            return valido;
        },
        formatDate(dates) {
            if (dates === undefined)return "Error de Fecha" 
            try {
                 var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
                "Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
                return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()-1]} del ${(new Date(Date.parse(dates))).getFullYear()}`
            } catch (error) {
                console.log(error);
                return "Error de Fecha"
            } 
        },
        acuse(){  
           var doc = new jsPDF('p', 'pt',[600, 600]);
            var img = new Image()
            img.src = '/refividrio.png';   
            doc.addImage(img,'png', 200, 0, 0, 0);  
            doc.autoTable({
                columnStyles: {europe: { halign: 'center' }},
                margin: { top: 100 }, 
                head: [[ 'SOLICITUD DE PROVEEDOR REFIVIDRIO (fecha de solicitud : ' + this.formatDate(this.solicitud.created_at)+")"]],
                body: [
                    ['Folio : ' + this.solicitud.folio],
                    ['RFC: ' + this.solicitud.tipoSolicitante[0].rfcColborador],
                    ['Referencia : ' + this.solicitud.tipoSolicitante[0].personaReferencia],  
                    ['Contacto de la Referencia : ' + this.solicitud.tipoSolicitante[0].celularReferencia], 
                    ['Parentezco : ' + this.solicitud.tipoSolicitante[0].parentezcoReferencia], 
                    ['Solicitante : ' + this.solicitud.nombreSolicitante],
                    ['Celular : ' + this.solicitud.numeroCelular],
                    ['Email : ' + this.solicitud.email],
                    ['Direccion : ' + this.solicitud.direccion],
                    ['Uso de CFDI : ' + this.solicitud.UsoCFDI], 
                    ['Tipo de Solicitante : ' + this.solicitud.tipoSolicitante[0].tipo], 
                    ['Razon Social : ' + this.solicitud.tipoSolicitante[0].razonSocial], 
                ]
                }, 
            );  
            doc.save('pre-registro.pdf'); 
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