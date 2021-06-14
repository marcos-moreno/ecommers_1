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
            <v-dialog v-model="dialog" width="900"> 
                <v-card>
                    <v-card-title class="justify-center headline grey lighten-2">
                        AVISO DE PRIVACIDAD
                    </v-card-title>
                    <aviso-privacidad/>
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
        <v-alert v-if="!isRegistrado" dense text type="success" class="my-2" icon="mdi-clock-fast" border="left"> 
            Completa tu PRE-REGISTRO, está sujeto a una aprobación por parte de Refividrio.
        </v-alert>
        <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
            {{msgError}}
        </v-alert>
        <div v-if="!isRegistrado">
            <v-container v-if="solicitud.tipoSolicitante.tipo != '' && tipoSolicitanteValido">  
                <v-btn icon color="blue" @click="tipoSolicitanteValido = false;msgError=''"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
                 <br>
                <v-chip  class="ma-2" color="primary" outlined pill>
                    <v-icon left>mdi-label</v-icon> 
                    <strong> {{solicitud.tipoSolicitante.tipo}}</strong>&nbsp; 
                </v-chip>
                <v-alert class="my-5" v-if="solicitud.montPreAprobed > 0" prominent text type="info">
                   Ya cuentas con un Crédito PRE-APROBADO de <strong>{{formatMXN(solicitud.montPreAprobed)}}</strong>
                </v-alert>

                <form class="my-8">
                    <v-text-field v-model="solicitud.nombreSolicitante" :error-messages="error.nombreSolicitante" :counter="100" 
                        label="*Nombre Completo" name="nombre" id="nombre" required @input="validaNombre()"  @blur="validaNombre()" >
                    </v-text-field>
                    
                    <v-row>
                        <v-col>
                            <v-text-field name="celular" id="celular" type="number"  v-model="solicitud.numeroCelular" :error-messages="error.numeroCelular"  
                                label="*Número Celular" required @input="validaCelular()" @blur="validaCelular()" :counter="10"
                                style="width:500px" 
                                onkeydown="javascript: return (event.keyCode == 69 ||event.keyCode == 109 
                                                            ||event.keyCode == 107||event.keyCode == 190
                                                            ||event.keyCode == 187||event.keyCode == 189 
                                                            ||event.keyCode == 229||event.keyCode == 189 
                                                            ) ? false : true"
                                  
                            >
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
                            <v-checkbox v-model="solicitud.requiredFactura"
                                label="¿Requiere Facturación?">
                            </v-checkbox>
                        </v-col>
                        <v-col>
                            <v-text-field name="rfc" id="rfc" v-model="solicitud.tipoSolicitante.rfcColborador" 
                                :error-messages="error.tipoSolicitante.rfcColborador" :counter="13" label="RFC"
                                style="width:400px" @input="validaRFC()" @blur="validaRFC()"
                                :disabled="solicitud.tipoSolicitante.tipo == 'Colaborador Refividrio'"
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
                                @change="validaDireccion()"
                            ></v-select> 
                        </v-col> 
                    </v-row>  

                    <v-row>
                        <v-col>
                           <!-- <v-btn @click="validarCp()">valida CP</v-btn> -->
                            <v-text-field name="cp" id="cp" @change="validarCp()" @input="validarCp()"
                                v-model="solicitud.cp" :error-messages="error.cp"
                                onkeydown="javascript: return (event.keyCode == 69 ||event.keyCode == 109 
                                    ||event.keyCode == 107||event.keyCode == 190
                                    ||event.keyCode == 187||event.keyCode == 189 
                                    ||event.keyCode == 229||event.keyCode == 189 
                                    ) ? false : true"
                                style="width:400px"
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
                                @change="validaDireccion()"
                                v-model="solicitud.asentamiento" :items="asentamientos"
                                label="Colonia" item-text="asentamiento"
                                item-value="asentamiento"
                                no-data-text="No hay Colonias disponibles"
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
                        label="He leído y acepto el aviso de privacidad" required>
                    </v-checkbox>
                    <a href="#" @click="dialog=true" >Leer el aviso de privacidad</a>
                    <br>
                    <v-btn class="my-10 mr-4" color="primary" @click="registrar()">
                        Registrar
                        <v-icon size="17">mdi-checkbox-marked-circle</v-icon>
                    </v-btn> 
                </form>
            </v-container>

            <v-container  class="my-10" v-else style="min-height:600px" > 

                <v-select prepend-icon="mdi-account"  
                    v-model="solicitud.tipoSolicitante.tipo" :items="tiposSolicitantes" @change="changeTipoSolicitante()"
                    :error-messages="error.tipoSolicitante.tipo" label="Tipo de Solicitante" required>
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
                                onkeydown="javascript: return (event.keyCode == 69 ||event.keyCode == 109 
                                                        ||event.keyCode == 107||event.keyCode == 190
                                                        ||event.keyCode == 187||event.keyCode == 189 
                                                        ||event.keyCode == 229||event.keyCode == 189 
                                                        ) ? false : true"
                                 @input="validaTipoSolicitante()"
                            >
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
                                @input="validaTipoSolicitante()" @blur="validaTipoSolicitante()" 
                            >
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
                <v-btn  class="my-10 mr-4" color="primary" dark  @click="nextTipoSolicitante()">
                    Continuar <v-icon size="17">mdi-arrow-right</v-icon>
                </v-btn>
            </v-container>
        </div>
        <v-container v-else style="min-height:700px" > 
            <v-alert type="success" text class="my-10"  border="left">
                ¡Gracias por tu solicitud!<br>
                Tu PRE-REGISTRO esta listo, nosotros te informaremos sobre el estatus de tu solicitud 
                en un périodo máximo de 3 días hábiles (no olvides revisar también tu bandeja de correo no deseado). 
            </v-alert> 
            <v-alert type="info" text class="my-10"  border="left"> 
                <br>*En caso de no recibir la información en el plazo máximo favor de contactarnos vía WhatsApp.
                <br>Para cualquier duda o aclaración comunicate al télefono 5551757108 
            </v-alert> 
            <div class="my-7">
                Si tu comprobante no se abrio en automático
                <v-btn small text @click="acuse()" color="primary">
                    click aqui para descargar
                </v-btn>
            </div>
            <v-simple-table>
                <template v-slot:default> 
                <tbody> 
                    <tr><td>Folio : <strong>{{solicitud.folio}}</strong></td></tr>
                    <tr><td>Tipo de Solicitante : {{solicitud.tipoSolicitante[0].tipo}}</td></tr>
                    <tr><td>Solicitante : {{solicitud.nombreSolicitante}}</td></tr>
                    <tr><td>RFC : {{ solicitud.tipoSolicitante[0].rfcColborador}}</td></tr>
                    <tr v-if="solicitud.montPreAprobed > 0" ><td>Crédito PRE-APROBADO : {{formatMXN(solicitud.montPreAprobed)}}</td></tr>
                    <tr><td>Celular : {{solicitud.numeroCelular}}</td></tr>
                    <tr><td>Correo Electrónico : {{solicitud.email}}</td></tr>
                    <tr v-if="solicitud.tipoSolicitante.tipo == 'Distribuidor' ||solicitud.tipoSolicitante.tipo == 'Recomendado por Familiar/Amigo'  "><td></td></tr>
                    <tr v-if="solicitud.tipoSolicitante.tipo == 'Distribuidor'">
                        <td>Razon Social : {{solicitud.tipoSolicitante[0].razonSocial}}</td>
                    </tr>
                    <tr v-if="solicitud.tipoSolicitante.tipo == 'Recomendado por Familiar/Amigo'">
                        <td>
                            Referencia : {{solicitud.tipoSolicitante[0].personaReferencia}}
                        </td>
                    </tr>  
                    <tr v-if="solicitud.tipoSolicitante.tipo == 'Recomendado por Familiar/Amigo'">
                        <td>
                            Contacto de la Referencia : {{solicitud.tipoSolicitante[0].celularReferencia}}
                        </td>
                    </tr> 
                    <tr v-if="solicitud.tipoSolicitante.tipo == 'Recomendado por Familiar/Amigo'">
                        <td>
                            Parentezco : {{solicitud.tipoSolicitante[0].parentezcoReferencia}}
                        </td>
                    </tr> 
                    <tr v-if="solicitud.requiredFactura"><td><center><strong>DATOS DE FACTURACIÓN</strong></center></td></tr>
                    <tr v-if="solicitud.requiredFactura"><td>Uso de CFDI : {{searchUSOCFDI(solicitud.UsoCFDI)}}</td></tr>
                    <tr v-if="solicitud.requiredFactura"><td>Calle y Número : {{solicitud.direccion}}</td></tr>
                    <!-- <tr><td>Ciudad : {{ solicitud.ciudad}}</td></tr>  -->
                    <tr v-if="solicitud.requiredFactura"><td>Colonia : {{ solicitud.asentamiento}}</td></tr>  
                    <tr v-if="solicitud.requiredFactura"><td>Municipio : {{ solicitud.municipio}}</td></tr>
                    <tr v-if="solicitud.requiredFactura"><td>Estado : {{ solicitud.estado}}</td></tr>  
                    <tr v-if="solicitud.requiredFactura"><td>Código Postal : {{solicitud.cp}}</td></tr> 
                </tbody>
                </template>
            </v-simple-table>
            <br><br><br><br><br>
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
import AvisoPrivacidadpr from '../components/AvisoPrivacidadpr.vue'; 
const validateRfc = require('validate-rfc');

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
        'aviso-privacidad' :AvisoPrivacidadpr
    },
    async created(){  
        // this.acuse();
        this.resetSolicitud(); 
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
        random(min, max) {
            return Math.round(Math.random() * (max - min) + min);
            // let i=0;
            // let arraLet =['A','B','C','D','E','F','G','H','I','J','K','Z','M','N'];
            // let arraLnUM =['1','2','3','4','5','6','7','8','9','0'];
            // while (i<800) {
            //     i++;
            //     let RFC = arraLet[this.i(0,13)] +arraLet[this.i(0,13)] + arraLet[this.i(0,13)]+arraLet[this.i(0,13)];
            //     RFC += arraLnUM[this.i(0,9)] +arraLnUM[this.i(0,9)] + arraLnUM[this.i(0,9)]+arraLnUM[this.i(0,9)]+arraLnUM[this.i(0,9)]+arraLnUM[this.i(0,9)];
            //     RFC += arraLet[this.i(0,13)] +arraLet[this.i(0,13)];
            //     RFC += arraLnUM[this.i(0,9)];
            //     const rfcRespuesta = validateRfc(RFC);
            //     console.log(RFC);  
            //     console.log(rfcRespuesta);  
            // }
        },
        validaRFC(){
            if (this.tipoSolicitanteValido == false || this.solicitud.tipoSolicitante.tipo == "Colaborador Refividrio") { 
                const rfcRespuesta = validateRfc(this.solicitud.tipoSolicitante.rfcColborador.trim());
                if(rfcRespuesta.isValid  && rfcRespuesta.type != "generic")
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
                if(rfcRespuesta.isValid && rfcRespuesta.type != "generic")
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
                let uriCp = `https://api.copomex.com/query/info_cp/${this.solicitud.cp}?token=3bda8a59-91e8-4b44-a534-1761a6e60335`;
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
                        return false;
                    } 
                }).catch(err=>{ 
                    console.log(err);
                    document.getElementById("cp").blur(); 
                    this.msgError = "El Código Postal ingresado es Inválido.";
                    this.error.cp = "El Código Postal ingresado es Inválido.";
                    window.scrollTo(0,0);
                    return false;
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
        },
        changeTipoSolicitante(){
            this.resetSolicitud();
        },  
        validaNombre(){ 
            this.solicitud.nombreSolicitante = this.solicitud.nombreSolicitante.trim();
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
                // if (this.solicitud.email.includes('refividrio.com')
                //     ||this.solicitud.email.includes('rfhoods.com')) {
                //     this.error.email = "No uses un correo electrónico de la empresa.";
                //     return false;
                // }
                return true;
            }else{
                this.error.email = "Correo Electrónico inválido";
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
                    if (!this.validaRFC()) { 
                        valido = false;
                    }
                    break;
                default:
                    break;
            } 
            return valido;
        },async nextTipoSolicitante(){  
            this.isLoad = true;
            if (this.validaTipoSolicitante()) {
                try {
                    const resMountPre = await axios.get(config.apiAdempiere + "/preregistro/montPreAproved"
                    ,{headers: {},params: {rfc: this.solicitud.tipoSolicitante.rfcColborador}})
                    .then(res=>{return res.data;})
                    .catch(err=>{return err;});
                    if (resMountPre.status == "success") { 
                        if (resMountPre.data.length > 0) {
                            this.solicitud.montPreAprobed = resMountPre.data[0].monto;
                            this.solicitud.nombreSolicitante = resMountPre.data[0].name; 
                        }
                    }else{
                        this.solicitud.montPreAprobed = 0;
                    }  
                } catch (error) {
                    console.log(error);
                } 
                this.tipoSolicitanteValido = true;
            }
            this.isLoad = false;
        },validaTerminos(){
            let valido = true;
            if (this.terminos == false) {
                this.error.terminosError = "Es necesario que aceptes el aviso de privacidad.";
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
            if (!this.terminos) {
                valido = false; 
            } 
            if (!this.validaRFC()) {
                 valido = false;
            }
            if (!await this.validarCp()) {
                 valido = false;
            } 
            if (valido) { 
                this.isLoad = true;
                this.solicitud.estado_solicitud = "PA";
                // console.log(JSON.stringify(this.solicitud));
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
                            if (result.data == "rfcDuplicado") {
                                this.msgError = "Parece que ya hay una solicitud con este RFC de solicitante, por favor verificalo."; 
                                this.isLoad = false;
                                window.scrollTo(0,0);
                                return;
                            }
                            try {
                                if (result.data.errors.email != undefined) {
                                    if (result.data.errors.email.kind == "unique") {
                                        this.msgError = "Parece que ya hay una solicitud con este Email de solicitante, por favor verificalo."; 
                                    }else{
                                        this.msgError = "Parece que ya hay una ERROR con este Email, por favor verificalo."; 
                                    }
                                    this.isLoad = false;
                                    window.scrollTo(0,0);
                                    return;
                                }
                            } catch (error) {
                                console.log({"if (result.data.errors.email != undefined)":error});
                            } 
                            try {
                                if (result.data.errors.numeroCelular != undefined) {
                                    if (result.data.errors.numeroCelular.kind == "unique") {
                                        this.msgError = "Parece que ya hay una solicitud con este celular, por favor verificalo."; 
                                    }else{
                                        this.msgError = "Parece que ya hay una ERROR con este celular, por favor verificalo."; 
                                    }
                                    this.isLoad = false;
                                    window.scrollTo(0,0);
                                    return;
                                } 
                            } catch (error) {
                                console.log({"if (result.data.errors.numeroCelular != undefined)":error});
                            }  
                            this.msgError = result.data; 
                        } catch (error) {
                            console.log({"##":error});
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
        },validaDireccion(){
            let valido = true;
            if (this.solicitud.requiredFactura) {
                // if (this.solicitud.tipoSolicitante.rfcColborador != "" 
                //     && (this.solicitud.tipoSolicitante.rfcColborador.trim().length == 13 
                //         ||
                //         this.solicitud.tipoSolicitante.rfcColborador.trim().length == 12
                //     )) {
                //     this.error.tipoSolicitante.rfcColborador="";
                // }else{
                //     valido = false;
                //     this.error.tipoSolicitante.rfcColborador="Para la facturación debé ser válido tu RFC 12-13 Digitos.";
                // }
                this.solicitud.direccion = this.solicitud.direccion.trim();
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
        formatDate(dates) {
            if (dates === undefined)return "Error de Fecha" 
            try {
                 var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
                "Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
                return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()]} del ${(new Date(Date.parse(dates))).getFullYear()}`
            } catch (error) {
                console.log(error);
                return "Error de Fecha"
            } 
        },
        searchUSOCFDI(code){
            for (let index = 0; index < this.usosCFDI.length; index++) {
                const element = this.usosCFDI[index];
                if (element.value == code) {
                    return element.name;
                }
            } 
        },
        acuse(){  
           var doc = new jsPDF('p', 'pt',[700, 380]);
            var img = new Image()
            img.src = '/refivid.png';   
            doc.addImage(img,'png', 95, 10, 0, 0);   
            doc.setTextColor(0, 106, 164 );
            doc.setFontSize(10);
            doc.text(110,110,'¡GRACIAS POR TU SOLICITUD!')
            doc.text(64,120,'Te enviaremos un correo cuando se complete tu registro.')
            doc.text(112,130,'¡El momento de crecer es ahora!') 
            let bodyTBL= [
                    //  ['Folio : ' , this.solicitud.folio]
                    ['Fecha de Solicitud : ' , this.formatDate(this.solicitud.created_at)]
                    ,['Tipo de Solicitante : ',this.solicitud.tipoSolicitante[0].tipo]
                    ,['Solicitante : ' ,this.solicitud.nombreSolicitante] 
                    ,['RFC : ' ,this.solicitud.tipoSolicitante[0].rfcColborador] 
                    ,['Celular : ',this.solicitud.numeroCelular]
                    ,['Correo Electrónico : ',this.solicitud.email]
                ];  
                if (this.solicitud.montPreAprobed > 0) {
                    bodyTBL.push(  
                       ['Crédito \nPRE-APROBADO : ',this.formatMXN(this.solicitud.montPreAprobed)]
                    );
                }
                if (this.solicitud.tipoSolicitante.tipo == 'Distribuidor') {
                    bodyTBL.push(  
                       ['Razon Social : ',this.solicitud.tipoSolicitante[0].razonSocial]
                    );
                }
                if (this.solicitud.tipoSolicitante.tipo == 'Recomendado por Familiar/Amigo') {
                    bodyTBL.push(  
                        ['Referencia : ' ,this.solicitud.tipoSolicitante[0].personaReferencia]  
                        ,['Contacto de la Referencia : ' ,this.solicitud.tipoSolicitante[0].celularReferencia] 
                        ,['Parentezco : ' ,this.solicitud.tipoSolicitante[0].parentezcoReferencia]  
                    );
                } 
                if (this.solicitud.requiredFactura) {
                    bodyTBL.push(  
                        ['Uso de CFDI : ' ,this.searchUSOCFDI(this.solicitud.UsoCFDI)] 
                        ,['Calle y Número : ' , this.solicitud.direccion] 
                        ,['Colonia : ' , this.solicitud.asentamiento] 
                        // ,['Ciudad : ' , this.solicitud.ciudad]  
                        ,['Municipio : ' , this.solicitud.municipio] 
                        ,['Estado : ' , this.solicitud.estado]  
                        ,['Código Postal : ' , this.solicitud.cp]  
                    );
                }

            var header = function () {
                doc.setFontSize(10); 
                doc.setTextColor(176, 176, 176 );
                doc.text("SOLICITUD DE DISTRIBUIDOR",110, 90);
            };
            doc.autoTable({
                columnStyles: {europe: { halign: 'center' }},
                margin: { top: 140 }, 
                head: [['Folio : ' , this.solicitud.folio]],
                body: bodyTBL
                ,didDrawPage: header
                }, 
            );
            let finalY = doc.lastAutoTable.finalY;
            doc.setFontSize(8);
            doc.text(45, finalY+18,'Para cualquier duda o aclaración comunicate al télefono 5551757108.')
            doc.setFontSize(8);
            doc.text(45, finalY+28,'Las compras en línea estarán disponibles a partir del 14 de JUNIO del 2021.')
            // doc.save('pre-registro.pdf'); 
            // doc.output();
            if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                window.open(doc.output("bloburl"), "_blank");   
            } else {
                doc.save('pre-registro.pdf');
            } 
        }
        ,formatMXN(value) {
            var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
            return formatter.format(value);
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