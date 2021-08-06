<template> 
  <div>
  <app-menu/>
  <v-container class="grey lighten-5" style="min-height:756px;"  >
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

    <div class="text-center">
    <v-dialog  v-model="dialogTransferencia"  width="500"  > 
      <v-card>
        <v-card-title class="text-h5 grey lighten-2">
          Transferencia electrónica
        </v-card-title> 
        <v-card-text>
          Por favor, transfiere el importe de la orden a nuestra cuenta bancaria. 
          Recibirás nuestra confirmación de pedido por correo electrónico con los datos bancarios y el número de pedido. 
          Los bienes se reservarán 3 días y procesaremos el pedido inmediatamente tras las recepción del pago.
          <br>Por favor, incluye el número de orden de tu pedido en los detalles de la transferencia bancaria.
          <br>
          <!-- <p>
            <strong>Tu fecha de entrega ingresada se omitirá y se te solicitará de nuevo una vez que tu pago sea confirmado.</strong>
          </p> -->
        </v-card-text>
        <v-divider></v-divider> 
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" text @click="dialogTransferencia = false" >
            Aceptar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    
    <v-dialog transition="dialog-top-transition" persistent  v-model="dialogRegalo"  max-width="700"  > 
      <v-card> 
          <v-card dark>
            <div class="d-flex flex-no-wrap justify-space-between">
              <div>
                <v-card-title class="text-h5">Felicidades</v-card-title> 
                <v-card-subtitle class="text-h6">Has recibido un regalo por tu compra</v-card-subtitle> 
              </div> 
              <v-avatar class="ma-3"  size="125" tile >
                <v-img src="../../public/caja-de-regalo.svg"></v-img>
              </v-avatar>
            </div>
          </v-card> 
        <v-divider></v-divider>  
        <center class="my-5">Selecciona tu producto de regalo</center> 
        <!-- {{saleOrder.productoregalo}} -->
        <v-radio-group v-model="saleOrder.productoregalo">  
          <v-card v-for="producto in productosRegalo" :key="producto.value">
              <div width="98%" style="margin-left:15px" class="d-flex flex-no-wrap justify-space-between">
                <div class="my-9">
                  <v-radio :label="producto.name.substring(0,83)" :value="producto.m_product_id" ></v-radio>
                  <p style="color:#7D7D7D">{{producto.value}}</p> 
                </div> 
                <v-avatar class="ma-3"  size="125" tile >
                  <v-img :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" ></v-img>
                </v-avatar>
              </div>
          </v-card>
        </v-radio-group>  
        <v-card-actions>
          <v-btn color="primary" text @click="regaloSeleccionado()" >
            Aceptar
          </v-btn> 
          <v-spacer></v-spacer> 
          <v-alert v-if="msgError!=''" dense outlined type="error">
          {{msgError}}
          </v-alert>  
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div> 
    <template v-if="shopingcarlength > 0" >

      <v-alert v-if="msgSucces!=''" dense text type="success">
        {{msgSucces}}
      </v-alert>
      <v-alert v-if="msgError!='' && dialogRegalo == false" dense outlined type="error">
        {{msgError}}
      </v-alert> 
      <div v-if="creditoExedido == false">
        <v-container v-if="calculaTotalCar_fn() >= montoMinimoCompra && isSucursal" style="min-height:656px;">
          <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
              ¿Dónde recolectarás tu compra?
            </p>  
            <v-img class="mx-auto text-center" width="70" src="../../public/tienda.png" ></v-img> 
            <v-radio-group v-model="sucursalSelec">  
              <v-simple-table class="my-15" >
                <template v-slot:default>
                  <tbody> 
                    <tr v-for="sucursal in sucursales" :key="sucursal.value"> 
                      <td>
                        <v-radio :label="sucursal.name" :value="sucursal.ad_org_id" >
                        </v-radio>
                      </td>
                      <td>
                        <a target="_blank"  :href="sucursal.url_maps">
                        <v-btn text color="primary"> 
                        <v-img width="20" src="../../public/ubicacion.png" ></v-img>
                        </v-btn>  
                        </a>
                      </td>
                    </tr> 
                  </tbody>
                </template>
              </v-simple-table>  
              <br><br><br>
              <v-row>  
                <v-col class="mx-auto text-center"> 
                  <v-btn @click="nexSteepSucSelect()" 
                  class="mx-auto" color="primary" width="50%" large>
                    CONTINUAR
                  </v-btn>            
                </v-col> 
              </v-row> 
            </v-radio-group>
          </v-card>  
      </v-container>

      <v-container v-if="isPay==true && calculaTotalCar_fn() >= montoMinimoCompra" style="min-height:656px;">
            <v-card style="min-height:186px;"> 
              <v-btn class="text-center" color="primary" text  @click="returnSucursal()" > 
                <v-icon>mdi-arrow-left</v-icon>Elegir otra sucursal
              </v-btn> 
              <p class="text-center" style="font-size: 1em;color :#909090">  
              Elige tu método de pago   
              </p>  
              <p class="text-center" style="font-size: 2em;color :#909090">  
              Total a pagar:
                <br><center>{{formatMXN(calculaTotalCar_fn())}}</center>
              </p>   
              <v-container >
                <v-row dense> 
                    <v-col cols="12">
                    <v-card color="#">
                      <div class="d-flex flex-no-wrap justify-space-between">
                        <div>
                          <v-card-title>Recoger en: {{buscaSucursal(sucursalSelec)}}</v-card-title> 
                          <v-card-title class="text-h5">Genera Factura</v-card-title> 
                          <v-card-subtitle >
                            <v-row no-gutters>
                              <v-col cols="6" md="4">
                                <v-switch disabled v-model="factura" :label="factura?'Si':'No'"></v-switch>
                              </v-col>
                              <v-col cols="12" sm="6" md="8" v-if="msgFactura != ''">
                                <v-alert  dense outlined :type="typeMsgFactura">
                                  {{msgFactura}}
                                </v-alert>
                              </v-col>
                            </v-row>
                          </v-card-subtitle> 
                        </div> 
                      </div>
                    </v-card> 
                  </v-col>

                  <v-col cols="12">
                    <v-card color="#1F7087"  dark v-if="validaCredito" >
                      <div class="d-flex flex-no-wrap justify-space-between">
                        <div>
                          <v-card-title class="text-h5">Crédito Refividrio</v-card-title> 
                          <v-card-subtitle >Crédito disponible {{formatMXN(creditoDisponible())}}</v-card-subtitle>
                          <v-card-actions>
                            <v-radio-group  v-model="methodPay"> 
                              <v-radio @click="changeMethodPay()" label="Crédito Refividrio" value="CRE" ></v-radio>
                            </v-radio-group>
                          </v-card-actions>
                        </div> 
                        <v-avatar class="ma-3" size="60" tile >
                          <v-img src="../../public/tdc.png" ></v-img>
                        </v-avatar>
                      </div>
                    </v-card> 
                  </v-col>

                  <v-col cols="12">
                    <v-card color="#305A81"  dark>
                      <div class="d-flex flex-no-wrap justify-space-between">
                        <div> 
                          <v-card-title class="text-h5">Transferencia electrónica</v-card-title> 
                          <v-card-subtitle > 
                            <v-btn rounded color="primary" @click="dialogTransferencia=true">
                                <v-icon left>mdi-format-list-bulleted-square</v-icon> 
                                Ver procedimiento 
                            </v-btn>
                          </v-card-subtitle> 
                          <v-card-actions>
                            <v-radio-group  v-model="methodPay"> 
                              <v-radio @click="changeMethodPay()" label="Transferencia electrónica" value="TRA" ></v-radio>
                            </v-radio-group>
                          </v-card-actions>
                        </div> 
                        <!-- <v-avatar class="ma-3" size="50" tile > -->
                          <!-- <v-img width="20%" src="../../public/transferencia-bancaria.svg" ></v-img> -->
                        <!-- </v-avatar> -->
                      </div>
                    </v-card> 
                  </v-col>

                  <v-col cols="12" v-if="sucursalSelec == 1000005" >
                    <v-card color="#4E7394" dark>
                      <div class="d-flex flex-no-wrap justify-space-between">
                        <div>
                          <v-card-title class="text-h5">Pago en Sucursal</v-card-title>
                          <!-- <v-card-subtitle > 
                              Esta forma de pago solo esta disponible para la {{buscaSucursal(1000005)}}
                          </v-card-subtitle> -->
                          <v-card-actions> <!--:disabled="sucursalSelec != 1000005"-->
                            <v-radio-group v-model="methodPay" > 
                              <v-radio @click="changeMethodPay()" label="Pago en efectivo en Sucursal" value="EFE"  ></v-radio>
                            </v-radio-group>
                          </v-card-actions>
                        </div> 
                        <v-avatar class="ma-3" size="55" tile >
                          <v-img src="../../public/tienda.png" ></v-img>
                        </v-avatar>
                      </div>
                    </v-card> 
                  </v-col>
                </v-row>
              </v-container>  

              <v-container>
                <v-row dense> 
                  <v-col cols="12">
                    <v-card color="#C3DDF5">
                      <div class="d-flex flex-no-wrap justify-space-between">
                        <div>
                          <v-card-title class="text-h5">Pago en linea</v-card-title>
                          <v-card-subtitle >
                            Tu pago se acredita al momento.
                          </v-card-subtitle>    
                          <!-- env="sandbox"  
                              :items="payProducts"
                          -->
                            <PayPal 
                              :amount="calculaTotalCar_fn().toString()"
                              currency="MXN"
                              :client="credentials"  
                              v-on:payment-authorized="paymentAuthorized"
                              v-on:payment-completed="paymentCompleted"
                              v-on:payment-cancelled="paymentCancelled"
                              :button-style="paypalStyle"
                              ></PayPal>  
                        </div> 
                        <v-avatar class="ma-3" size="55" tile >
                          <v-img src="../../public/paypal.png" ></v-img>
                        </v-avatar>
                      </div>
                    </v-card> 
                  </v-col>
                  </v-row>
              </v-container>   

              <v-container v-if="methodPay=='EFE' && isLoad == false">
                <v-row > 
                    <v-col cols="12" sm="7"> 
                      <v-alert border="top" colored-border type="info" elevation="2">
                          ¿Qué día recojerás tu pedido? 
                        <v-radio-group  v-model="recoleccion" >  
                            <v-radio  v-for="dia in diasEntregaPagoSucursal" :key="dia.fecha" 
                            :label="`${formatDate(dia.fecha)} a partir de las ${dia.hora}:00 hrs. `" :value="dia" ></v-radio>
                        </v-radio-group>  
                      </v-alert> 
                  </v-col>
                  <v-col cols="12" sm="5">
                    <v-alert border="top" colored-border type="info" elevation="2" color="cyan">
                            Horarios de atención en sucursal:<br><br>
                            Lunes a Viernes <br> 9:00 hrs.  hasta 18:30 hrs.<br><br>
                            Sabado <br> 9:00 hrs. hasta 14:30 hrs.<br>
                    </v-alert>
                  </v-col>
                </v-row>
              </v-container>  

              <v-container fluid v-if="methodPay=='CRE' && isLoad == false" > 
                <v-alert type="success" ><strong>{{diasEntrega.texto}} </strong></v-alert>
                <v-alert border="top" colored-border type="info" color="cyan"  elevation="2">
                  Horarios de atención en sucursal:<br>
                  Lunes a Viernes de 9:00 hrs.  hasta 18:30 hrs.<br>
                  Sabado de 9:00 hrs. hasta 14:30 hrs.<br>
                </v-alert>
              </v-container>

              <v-container fluid v-if="methodPay=='TRA'"> 
                <v-alert type="warning" elevation="10"  colored-border border="bottom">
                  <div>Una vez que se valide tu pago te enviaremos un correo de confirmación de tu compra
                    en el cual se indicará a partir de que día estará disponible tu pedido para 
                    su entrega.</div>
                </v-alert>
              </v-container>
 
              <br><br><br> 
              <v-row>  
                <v-col class="mx-auto text-center">  
                  <v-btn 
                  @click="confirmarCompra()" class="mx-auto" style="color:#fff;" color="primary" width="250px" large>
                    CONFIRMAR COMPRA
                  </v-btn>            
                </v-col> 
              </v-row> 
          </v-card>    
        </v-container> 

        <v-container v-if="calculaTotalCar_fn() < montoMinimoCompra && creditoExedido == false"  style="min-height:656px;"  >
          <div>
            <v-card  style="min-height:286px;"> 
                <center>
                  <img class="my-5" src="../../public/carrito-de-compras.svg" width="100px" />
                </center>
                <p class="text-center" style="font-size: 1.5em;color :#909090">  
                La compra mínima es por el monto de<br> {{formatMXN(montoMinimoCompra)}}
                <br>El costo de tu carrito es de <br>{{formatMXN(calculaTotalCar_fn())}} 
                </p>
                <br> 
            </v-card> 
          </div>
        </v-container>
      </div>

      <v-container v-if="creditoExedido==true && isLoad == false"  style="min-height:656px;"  >
        <div>
          <v-card  style="min-height:286px;"> 
              <center>
                <img class="my-5" src="../../public/credito.svg" width="100px" />
              </center>
              <p class="text-center" style="font-size: 1.5em;color :#909090">  
                Al parecer has excedido el tiempo límite para el pago de tu Crédito. 
              </p>
              <p class="text-center" style="font-size: 1.2em;color :#909090">  
                Debes saldar estas ordenes para seguir comprando en Refividrio.
              </p> 
              <v-card v-for="(item, i) in facturasPendientes" :key="i"  class="mx-auto" max-width="500" >
                <v-card-text> 
                  <center>
                    <p class="text-h5">No. Orden: {{item.orden}}</p>
                    <p>No. Factura: {{item.factura}}</p> 
                    <p class="text-h5" >{{formatMXN(item.pendientecobrar)}}</p>
                  </center>
                </v-card-text> 
              </v-card>
              
              <br> 

              <v-card class="mx-auto" max-width="90%" >
                <v-card-text> 
                  <center>
                    <p class="text-h5 text--primary">
                      Información que necesitas para realizar tu pago por Transferencia electrónica:
                    </p>
                    <p>Titular de la cuenta: RFV TRUCK PARTS AND ACCESSORIES SA DE CV</p> 
                    <p>Detalles de la cuenta: No. Cuenta: 0116523536</p> 
                    <p>No. Cuenta CLABE: 012180001165235368</p> 
                    <p>Dirección del banco: Bancomer</p> 
                    <p style="color:#13089B" >
                      <strong>
                        Por favor, incluye el número de orden en los detalles de la transferencia bancaria.
                      </strong>
                    </p>
                    <p class="text-h5" ></p>
                  </center>
                </v-card-text> 
              </v-card>
              <br> 
          </v-card> 
        </div>
      </v-container>

    </template>

    <v-container v-if="shopingcarlength == 0 && isLoad == false && this.saleOrder.status_pay != 'pagado'"  style="min-height:656px;"  >
      <div>
        <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
              Tu cesta está vacía
            </p> 
        </v-card> 
      </div>  
    </v-container>

  </v-container>  
  </div>  
</template>

<style scoped>
  .centered-input >>> input {
    text-align: center
  }
</style> 

<script> 
import config from '../json/config.json'
import axios from 'axios'; 
import PayPal from 'vue-paypal-checkout'
const validateRfc = require('validate-rfc');  
import AppMenu from '../components/Menu.vue';
import jsPDF from 'jspdf';
export default {
  name: "appBuy",
  data() {
    return { 
      sucursalSelec : 0 
      ,montoMinimoCompra : 1000
      ,montoParaRegalo : 5000
      ,dialogRegalo : false
      ,dialogTransferencia: false
      ,creditoExedido : true
      ,recoleccion : {fecha:'',texto:'',horaprometida:''}
      ,diasEntrega : {}
      ,diasEntregaPagoSucursal : []
      ,msgFactura : ''
      ,typeMsgFactura : ''
      ,productos : []
      ,isLogged : false
      ,user : {}
      ,isLoad : false  
      ,sucursales : []
      ,isPay : false
      ,methodPay : 0
      ,isSucursal : false
      // ,enaContinueMPay : true  
      ,credentials: {
        sandbox: 'AW7-JDeyq1fAlr6z7qSvDe8nQleAbYDLI90q4CKd4WwIXgE3EhedLlYY5uOG6iLkOGAEhev4Fo3eAD_I',
        production: 'AYf3eZYPLzr4W6cVSST2pXPWkdUMiFwf1_QHZeHRvIGPZSb_Kx-zBzt4WiUW-g9Oh6iT9iqIiOTuaDaO'
      }
      ,payProducts: []
      ,paypalStyle: {label:'checkout',size:'responsive',shape:'pill',color:'blue'}
      ,msgSucces:"",msgError:""
      ,saleOrder : {
        status_pay:"",paymentAuthorized:""
        ,paymentCompleted:"",paymentCancelled:""
        ,c_order_id:"-",documentno : "-"
        ,estado_pago:"-",_id : ""
        ,method_pay : ""
        ,productos:[]
        ,productoregalo : 0
      } 
      ,factura:false
      ,facturasPendientes : []
      ,productosRegalo : []
    }; 
  }, 
  async created() { 
    this.isLoad = true;  
    await this.validaLogin();
    await this.getproductsRegalo();
    if (this.isLogged) {
      await this.allSucursales();
      await this.allProductinCar(); 
      await this.verifiedCreditExedido();   
      for (let index = 0; index < this.productos.length; index++) { 
          let Qtyordenada = 0;
          if ((this.productos[index].mex_quantytotal - this.productos[index].cantidad) < 0) {
            Qtyordenada =  (this.productos[index].mex_quantytotal - this.productos[index].cantidad) * -1;
          }
          this.saleOrder.productos.push(
          {
            "quantity": this.productos[index].cantidad
            ,"price": parseFloat(this.productos[index].l0)
            ,"total": (
                        parseFloat(this.productos[index].l0)
                          *
                        this.productos[index].cantidad
                      )
            ,"m_product_id":this.productos[index].m_product_id
            ,"cantidadExistente": this.productos[index].mex_quantytotal
            ,"cantidadOrdenada": Qtyordenada
            ,"value":this.productos[index].value  
            ,"name":this.productos[index].name  
          });
      }    
      this.saleOrder.c_bpartner_id = this.user.c_bpartner_id;
      this.saleOrder.ad_user_id = this.user.ad_user_id; 
      this.saleOrder.grandtotal = this.calculaTotalCar_fn(); 
      this.saleOrder.status_entrega = "pendiente";  
      this.saleOrder.m_pricelist_id = this.user.m_pricelist_id;
      window.scrollTo(0,0);
    }else{
      this.menu('/shop/Login/');
    }
    this.isLoad = false;  
    this.isSucursal = true; 
  }
  ,methods: {
    async buscarDiasRuta(){ 
      this.saleOrder.method_pay = this.methodPay; 
      this.isLoad = true;
      let sucursal = {};
      for (let index = 0; index < this.sucursales.length; index++) {
          const element = this.sucursales[index];  
          if(element.ad_org_id == this.sucursalSelec)
            sucursal = element;
      }   
      this.diasEntrega = {};
      this.diasEntrega = await axios.get(config.apiAdempiere + "/sucursal/get_dias_entrega"
        ,{headers: { 'token': this.$cookie.get('token') },params: {saleOrder:this.saleOrder,sucursal:sucursal}}
      ).then(res=>{ 
        return res.data.data;
      }).catch(err=>{return err;});
      if (this.methodPay == 'EFE') { 
          this.recoleccion = {fecha:'',texto:'',horaprometida:''};
         this.diasEntregaPagoSucursal = this.diasEntrega; 
      }else{
        this.recoleccion = this.diasEntrega;
      }
      this.isLoad = false;  
      window.scrollTo(1100,1000);
    }, 
    addDays(date, days) {
      var result = new Date(date);
      result.setDate(result.getDate() + days);
      return result;
    },
    buscaSucursal(idOrg){ 
      let nombreSucursal = "";
      this.sucursales.forEach(element => {
        if (element.ad_org_id == idOrg)nombreSucursal = element.name;
      }); 
      return nombreSucursal;
    }
    ,async confirmarCompra(){ 
      window.scrollTo(0,0);
      if (this.methodPay==0) {
        this.msgError = "Por favor selecciona una forma de pago.";
        return;
      }else{
        this.msgError = "";
      }  
      if (this.recoleccion.fecha == '') {
        this.msgError = "Por favor selecciona una fecha.";
        return;
      }
      this.isLoad = true; 
      const resIns = await this.insertSaleOrder()
      if (resIns)this.menu("/shop/purchases");  
      this.isLoad = false;
    }, 
    async insertSaleOrder(){ 
      this.saleOrder.fechaprometida = this.recoleccion.fecha; 
      this.saleOrder.fechaprometidatexto = this.recoleccion.texto; 
      this.saleOrder.horaprometida = this.recoleccion.hora; 
      
      this.saleOrder.ad_org_recpt_id = this.sucursalSelec;
      this.saleOrder.isfactura = this.factura;  
      this.saleOrder.emailClient = this.user.email;  
      this.saleOrder.nombre_cliente = this.user.cpname;  
      
      const result = await axios.post(
        config.apiAdempiere + "/saleorder/add_auth_with_ad", 
        this.saleOrder
      ,{headers:{'token': this.$cookie.get('token')}})
      .then(res=>{  
        return res.data;
      }).catch(err=>{
        console.log(err);
        this.msgError = err;
        return false;
      });
      console.log(result);
      if(result.status == "success"){ 
        this.saleOrder = result.data;  
        this.emptyCar();
        return true;
      }else{ 
        window.scrollTo(0,0);
        if (result.data == "Error Interno") {
          this.msgError = "Existe un error, por favor Comuníquese con el soporte al número: 55 51757108";
        }else{
          this.msgError = result.data;
        } 
        return false; 
      }   
    },
    changeMethodPay(){ 
      this.recoleccion = {fecha:'',texto:'',horaprometida:''};
      if (this.methodPay  == "CRE" || this.methodPay  == "EFE" || this.methodPay  == "paypal") {
        // this.enaContinueMPay = false; 
        this.saleOrder.method_pay = this.methodPay;
        if (this.methodPay  == "CRE" || this.methodPay  == "EFE") { 
          this.saleOrder.status_pay = "pendiente";
          if (this.methodPay  == "CRE") {
            this.saleOrder.estado_pago = "procesado";
          }else{
            this.saleOrder.estado_pago = "pendiente";
          }
        } 
      }else if(this.methodPay  == "TRA"){
        this.dialogTransferencia = true;
        this.saleOrder.status_pay = "pendiente"; 
        this.saleOrder.estado_pago = "pendiente";
        this.saleOrder.method_pay = this.methodPay;
      }else{
        // this.enaContinueMPay = true;
        this.methodPay = 0;
        this.saleOrder.method_pay = "";
      }
      this.buscarDiasRuta();
    }, 
    paymentAuthorized: function (data) {
      this.saleOrder.paymentAuthorized = data;
      this.saleOrder.status_pay = "paymentAuthorized";
      this.saleOrder.method_pay = "paypal";
      this.methodPay = "paypal";   
    }, 
    returnSucursal() {
      this.isPay = false;
      this.isSucursal = true; 
    },
    paymentCompleted: async function (data) {
      if (data.state == "approved") {
        this.isLoad = true;
        this.saleOrder.paymentCompleted = data; 
        this.saleOrder.status_pay = "pagado"; 
        this.methodPay = "paypal";
        try {
          const OSInsert = await this.insertSaleOrder(); 
          if (OSInsert)this.menu("/shop/purchases");   
        } catch (error) {
          console.log(error);
        }
        this.acuse();
        this.isLoad = false;
      } else {
        this.msgError = "El pago no se pudo completar";
        console.log(data);
      } 
    },
    acuse(){
        let data =  this.saleOrder.paymentCompleted;   
        var doc = new jsPDF('p', 'pt',[500, 380]);
        var img = new Image()
        img.src = '/refivid.png'; 
        doc.addImage(img,'png', 150, 18, 0, 0);   

        var img2 = new Image()
        img2.src = '/paypal.png'; 
        img2.width = "10px";
        doc.addImage(img2,'png', 80, 18, 55, 55);    

        doc.setTextColor(0,106,164);
        doc.setFontSize(11);
        doc.text(64,120,`Estimado/a ${data.payer.payer_info.first_name} ${data.payer.payer_info.last_name}`);
        doc.text(64,140,`Ha enviado un pago por importe de $${data.transactions[0].amount.total} MXN`);
        doc.text(112,165,'¡Muchas gracias por tu compra!');

        doc.setTextColor(0,0,0);
        doc.setFontSize(10);
        doc.text(64,190,`Esta transacción puede tardar unos momentos en aparecer`);
        doc.text(64,200,`en su cuenta.`);

        doc.setFontSize(10);
        doc.setTextColor(129, 129, 129); 
        doc.text(64,240,`Orden:`);
        doc.text(160,240,`${this.saleOrder.documentno}`);
        doc.text(64,260,`Id. de transacción:`);
        doc.text(160,260,`${data.transactions[0].related_resources[0].sale.id}`);
        doc.text(64,280,`Estado:`);
        doc.text(160,280,`${data.transactions[0].related_resources[0].sale.state=='completed'?'COMPLETO':data.transactions[0].related_resources[0].sale.state}`);
       
        doc.text(64,300,`Modo transferencia:`);
        doc.text(160,300,`${data.transactions[0].related_resources[0].sale.payment_mode=='INSTANT_TRANSFER'?'TRANSFERENCIA INSTANTÁNEA':data.transactions[0].related_resources[0].sale.payment_mode}`);
      
        doc.text(64,320,`Id. de la compra:`);
        doc.text(160,320,`${this.saleOrder._id}`);

        doc.text(64,340,`Fecha transacción:`);
        doc.text(160,340,`${this.formatDate(data.transactions[0].related_resources[0].sale.create_time)} ${this.formatTime(data.transactions[0].related_resources[0].sale.create_time)}
        `); 
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            window.open(doc.output("bloburl"), "_blank");   
        } else {
            doc.save(`comprobante de pago${data.transactions[0].related_resources[0].sale.id}.pdf`);
        }
    },
    formatDate(dates) { 
        var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
            "Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
        return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()]} del ${(new Date(Date.parse(dates))).getFullYear()}`
    },
    formatTime(dates) { 
        const hours = ('0' + (new Date(Date.parse(dates))).getHours()).slice(-2)
        const minutes = ('0' + (new Date(Date.parse(dates))).getMinutes()).slice(-2)
        return `${hours}:${minutes}`
    },
    async emptyCar(){
      for (let index = 0; index < this.productos.length; index++) {
        const element = this.productos[index];
        await axios.delete(config.apiAdempiere + "/shopingcar/deletebyvalue_auth", 
        { headers:{token: this.$cookie.get('token')}, data:{value: element.value}})
        .then(res=>{ 
          if(res.data.status != "success"){ console.log(res.data);} 
        }).catch(err=>{console.log(err);});  
      } 
      let inputCar = document.getElementById("cantidadInCar");
      if (inputCar != null) {
        inputCar.value = "";
      }
    },
    paymentCancelled: function (data) {
      this.saleOrder.paymentCancelled = data;
      this.saleOrder.status_pay = "paymentCancelled";
      // this.enaContinueMPay = true; 
      this.methodPay = 0;
    },
    // :::::::::::::::::::::Module Regalo
    async getproductsRegalo(){ 
      this.productosRegalo = []; 
      let uri = config.apiAdempiere + "/productos/all";
      this.productosRegalo = await axios.get(uri
      ,{
        headers: { 'token': this.$cookie.get('token') },
        params: {
            filter: 'P15UN097'
            ,onliStock : 0
            ,range : [0,5000]
            ,andalucia : true
            ,ld : true
            ,ordenMenorP : false
            ,ordenMayorP : false
            ,ordenMasVendido : false
        }
      }
      ).then(function (response) { 
        if (response.data.status == "success") {
          return response.data.data;
        } else {
          console.log(response.data.data);
          return [];
        }
      }).catch(function (response){ 
        console.log(response);
        return [];
      });   
    },
    regaloSeleccionado(){
      if (this.saleOrder.productoregalo == 0) {
        this.msgError = "Por favor selecciona tu regalo.";
      }else{
        this.changeDisplaySucursal();
      }
    },
    async nexSteepSucSelect(){
      window.scrollTo(0,0);
      if (this.calculaTotalCar_fn() >= this.montoParaRegalo) {
        if (this.sucursalSelec==0) {
          this.msgError = "Por favor selecciona la sucursal para tu entrega.";
          return;
        }else{
          this.msgError = "";
          this.dialogRegalo = true;
        }
      }else{
        this.changeDisplaySucursal();
      } 
    },
    changeDisplaySucursal(){ 
      this.dialogRegalo = false;
      if (this.sucursalSelec==0) {
        this.msgError = "Por favor selecciona la sucursal para tu entrega.";
        return;
      }else{
        this.msgError = "";
      }
      this.methodPay = 0;
      if (parseInt(this.sucursalSelec) > 0) {
          this.isPay = true;
          this.isSucursal = false; 
      }  
    },
    calculaTotalCar_fn(){
      let total = 0;
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          let subtotal =  (parseInt(element.cantidad) * parseFloat(element.siniva) * 1.16000000).toFixed(2);
          total += parseFloat(subtotal);
        } catch (error) { 
          return null;
        } 
      }   
      return parseFloat(total).toFixed(2);
    },
    async mounted() {
      window.scrollTo(0,0); 
    },
    menu(path){
      if (this.$route.path !== path){
        this.$router.push(path);
      }  
    }
    ,async validaLogin(){
        this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {'headers': { 'token': this.$cookie.get('token') }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});    
        if (this.user.status == "success") {
          this.user = this.user.user; 
          const rfcRespuesta = validateRfc(this.user.taxid)
          if(rfcRespuesta.isValid && rfcRespuesta.type != "generic"){
            this.factura = true;
            this.msgFactura = `Esta compra generará una factura al RFC ${this.user.taxid}`;
            this.typeMsgFactura = 'info';
          }else{
            this.factura = false;
            this.msgFactura = `Esta compra NO generará factura, en caso 
            de requerirla ponte en contacto con tu agente de ventas o al número 55-5175-7108.`;
            this.typeMsgFactura = 'warning';
          } 
          this.isLogged = true;
        }else if(this.user.status == "unauthorized"){ 
          this.isLogged = false;
          location.href = "/";
        }   
    },
    async allProductinCar(){
        let productsincar = await axios.get(config.apiAdempiere + "/shopingcar/getcomplete_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (productsincar.status == "success") {
          productsincar = productsincar.data;
        }else if(this.user.status == "unauthorized"){  
          productsincar = [];
        }  
        this.productos = productsincar;  
    },
    async allSucursales(){ 
        this.sucursales = await axios.get(config.apiAdempiere + "/sucursal/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data.data;})
        .catch(err=>{return err;});  
    }  
    ,formatMXN(value) {
        var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
        return `${formatter.format(value)} MXN`;
    }, 
    creditoDisponible(){
      return parseFloat(this.user.so_creditlimit) - parseFloat(this.user.so_creditused);
    }
    ,async verifiedCreditExedido(){
      let respuestaVC = await axios.get(config.apiAdempiere + "/partner/valida_credito"
        ,{headers:{'token': this.$cookie.get('token')}
      }).then(res=>{ 
        return res.data.data;
      }).catch(err=>{return err;});
      if (respuestaVC.status == 'success') {
        if (respuestaVC.data.length > 0) {
          this.facturasPendientes = respuestaVC.data;
          this.creditoExedido = true;
          window.scrollTo(0,0);
        }else{
          this.creditoExedido = false; 
        }
      }  
    },
  },  
  components: {
    PayPal,AppMenu
  }
  ,computed: {
    validaCredito(){
      if (this.user.socreditstatus == "X") {
        try {
          if (this.creditoDisponible() > this.calculaTotalCar_fn()) {
            return true;
          }
        } catch (error) { 
          return false;
        } 
      } 
      return false;
    },
    shopingcarlength(){
      return this.productos.length;
    }, 
  }
}
</script>
