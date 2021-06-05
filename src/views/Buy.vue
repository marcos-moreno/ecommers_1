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
    <template v-if="shopingcarlength > 0" >

      <v-alert v-if="msgSucces!=''" dense text type="success">
        {{msgSucces}}
      </v-alert>
      <v-alert v-if="msgError!=''" dense outlined type="error">
        {{msgError}}
      </v-alert>

      <v-container v-if="isSucursal" style="min-height:656px;">
        <v-card style="min-height:186px;">  
          <v-btn class="text-center" color="primary" text  @click="returnPago"
            v-if="saleOrder.method_pay != 'paypal' && saleOrder.status_pay != 'pagado'"> 
            <v-icon>mdi-arrow-left</v-icon>Cambiar forma de pago
          </v-btn> 
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
                      <v-radio :disabled="sucursal.value != 'S6' && methodPay == 'EFE'" :label="sucursal.name" :value="sucursal.ad_org_id" >
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
                <v-btn :disabled="sucursalSelec==0" @click="confirmarCompra"  class="mx-auto" color="primary" width="50%" large>
                  CONFIRMAR COMPRA
                </v-btn>            
              </v-col> 
            </v-row> 
          </v-radio-group>
        </v-card>  
    </v-container>

     <v-container v-if="isPay==true && calculaTotalCar_fn() >= montoMinimoCompra" style="min-height:656px;">
          <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 1em;color :#909090">  
             Elige tu método de pago   
            </p>  
            <p class="text-center" style="font-size: 2em;color :#909090">  
             Total a pagar:
              <br><center>{{calculaTotalCar}}</center>
            </p>   
            <v-container >
              <v-row dense> 
                  <v-col cols="12">
                  <v-card color="#">
                    <div class="d-flex flex-no-wrap justify-space-between">
                      <div>
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
                  <v-card color="#4E7394" dark>
                    <div class="d-flex flex-no-wrap justify-space-between">
                      <div>
                        <v-card-title class="text-h5">Pago en Sucursal</v-card-title>
                        <v-card-subtitle >
                          Tu compra no se reservará hasta que acredites tu pago, la existencia podría cambiar.
                        </v-card-subtitle>
                        <v-card-actions>
                          <v-radio-group v-model="methodPay"> 
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
                            :amount="total"
                            currency="MXN" 
                            :client="credentials"  
                            env="sandbox"
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
            <br><br><br> 
            <v-row>  
              <v-col class="mx-auto text-center"> 
                <v-btn :disabled="enaContinueMPay" @click="payComplet" class="mx-auto" color="primary" width="50%" large>
                  CONTINUAR
                </v-btn>            
              </v-col> 
            </v-row> 
        </v-card>    
      </v-container> 

      <v-container v-if="calculaTotalCar_fn() < montoMinimoCompra"  style="min-height:656px;"  >
        <div>
          <v-card  style="min-height:286px;"> 
              <center>
                <img class="my-5" src="../../public/carrito-de-compras.svg" width="100px" />
              </center>
              <p class="text-center" style="font-size: 1.5em;color :#909090">  
               La compra mínima es por el monto de<br> {{formatMXN(montoMinimoCompra)}} MXN
               <br>El costo de tu carrito es de <br>{{calculaTotalCar}} MXN
              </p> 
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
      ,montoMinimoCompra : 50
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
      ,enaContinueMPay : true 
      ,total : ""
      ,credentials: {
        sandbox: 'AW5asrqUKWfdNKSSMapnfEqBmXDOAqZ1r_BbfqOZbHDOukjMKDvNtqm5JGovrOzoG8xDan2kBXJbbZfT',
        production: 'AbEpHVkInyW2GzxG2fWPaLwvikiDqD2zh08oTUzEKuUsoq9Aq-OSybEHv2d1aQsH5CjbJglP3xnPY29S'
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
      } 
      ,factura:false
    }; 
  }, 
  async created() {
    window.scrollTo(0,0);
    this.isLoad = true;  
    await this.validaLogin();
    if (this.isLogged) {
      await this.allSucursales();
      await this.allProductinCar();
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
      this.total = this.calculaTotalCar_fn().toFixed(2).toString();
      this.saleOrder.c_bpartner_id = this.user.c_bpartner_id;
      this.saleOrder.ad_user_id = this.user.ad_user_id;
      this.saleOrder.grandtotal = this.calculaTotalCar_fn().toFixed(2);
      this.saleOrder.status_entrega = "pendiente";  
      this.saleOrder.m_pricelist_id = this.user.m_pricelist_id;
    }else{
      this.menu('/shop/Login/');
    }
    this.isLoad = false;  
    this.isPay = true; 
  }
  ,methods: { 
    async confirmarCompra(){
      if (this.sucursalSelec > 0) {
        this.isLoad = true;
        this.saleOrder.ad_org_recpt_id = this.sucursalSelec;
        if (this.methodPay  == "CRE" || this.methodPay  == "EFE") {
          const resIns = await this.insertSaleOrder()
          if (resIns)this.menu("/shop/purchases");  
        }else if(this.methodPay  == "paypal" && this.saleOrder.status_pay == "pagado"){
          const resUpd = await this.updateSaleOrder(); 
          if (resUpd)this.menu("/shop/purchases");  
        }
       this.isLoad = false;
      }else{
        this.sucursalSelec = 0;
      }
    },
    async updateSaleOrder(){ 
      const result =  await axios.put(config.apiAdempiere + "/saleorder/updatebyID_auth", 
                                      this.saleOrder
                                      ,{headers:{'token': this.$cookie.get('token')}}
                                    )
      .then(res=>{ 
        if(res.data.data.status != "success")return true; else return false;
      }).catch(err=>{
        console.log(err);
        this.msgError = err;
        return false;
      });    
      return result;    
    },
    async insertSaleOrder(){
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
      if(result.status == "success"){ 
        this.saleOrder = result.data;  
        console.log("RESULTADO DE LA ORDEN:");
        console.log(this.saleOrder);
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
      if (this.methodPay  == "CRE" || this.methodPay  == "EFE" || this.methodPay  == "paypal") {
        this.enaContinueMPay = false; 
        this.saleOrder.method_pay = this.methodPay;
        if (this.methodPay  == "CRE" || this.methodPay  == "EFE") { 
          this.saleOrder.status_pay = "pendiente";
          if (this.methodPay  == "CRE") {
            this.saleOrder.estado_pago = "procesado";
          }else{
            this.saleOrder.estado_pago = "pendiente";
          } 
        } 
      }else{
        this.enaContinueMPay = true; 
        this.saleOrder.method_pay = "";
      }
    }, 
    paymentAuthorized: function (data) {
      this.saleOrder.paymentAuthorized = data;
      this.saleOrder.status_pay = "paymentAuthorized";
      this.saleOrder.method_pay = "paypal";
      this.methodPay = "paypal";   
    }, 
    returnPago() {
      this.isPay = true;
      this.isSucursal = false; 
    },
    paymentCompleted: async function (data) {
      if (data.state == "approved") {
        this.isLoad = true;
        this.saleOrder.paymentCompleted = data; 
        this.saleOrder.status_pay = "pagado"; 
        this.methodPay = "paypal";
        try {
          const OSInsert = await this.insertSaleOrder(); 
          if (this.saleOrder._id != "" && OSInsert) {
            this.msgSucces = "Pago Procesado Exitosamente";
            this.changeMethodPay();
            this.isPay = false;
            this.isSucursal = true;
            window.scrollTo(0,0);
          }
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
        doc.text(64,140,`Ha enviado un pago por importe de ${data.transactions[0].amount.total} MXN a `);
        doc.text(112,165,'¡Muchas gracias por tu pago!');

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
        doc.save(`comprobante de pago${data.transactions[0].related_resources[0].sale.id}.pdf`); 
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
      this.enaContinueMPay = true; 
      this.methodPay = 0;
    },
    payComplet(){ 
      if ((this.saleOrder.method_pay == "paypal" && this.saleOrder.status_pay == "pagado" )
            || this.saleOrder.method_pay  == "CRE" 
            || this.saleOrder.method_pay  == "EFE" 
      ){
        if (this.saleOrder.method_pay  == "EFE" ) {
          this.sucursalSelec = "";
        }
        this.isPay = false;
        this.isSucursal = true;
        window.scrollTo(0,0);
      }else{
        this.enaContinueMPay = true; 
      }
    },
    calculaTotalCar_fn(){
      let total = 0;
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          total += (parseInt(element.cantidad) * parseFloat(element.l0));
        } catch (error) { 
          return null;
        } 
      }
      return total;
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
            de requerirla ponte en contacto con tu agente de ventas o al número 5551757108.`;
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
        var formatter = new Intl.NumberFormat('es-MX', {style: 'currency', currency: 'MXN',});
        return formatter.format(value);
    }, 
    creditoDisponible(){
      return parseFloat(this.user.so_creditlimit) - parseFloat(this.user.so_creditused);
    }
  },  
  components: {
      PayPal
      ,AppMenu
  }
  ,computed: {
    validaCredito(){ 
      if (this.user.socreditstatus != "S") { 
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
    },calculaTotalCar(){ 
      return this.formatMXN(this.calculaTotalCar_fn());
    },
  }
}
</script>
