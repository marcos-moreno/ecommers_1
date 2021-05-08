<template> 
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

     <v-container v-if="isPay==true" style="min-height:656px;">
          <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
             Elige tu método de pago   
            </p>  
            <p class="text-center" style="font-size: 2em;color :#909090">  
             Total a pagar: {{calculaTotalCar}}
            </p>   
            <v-container>
            <v-row dense> 
                <v-col cols="12">
                <v-card color="#">
                  <div class="d-flex flex-no-wrap justify-space-between">
                    <div>
                      <v-card-title class="text-h5">Requiero Factura</v-card-title> 
                      <v-card-subtitle >
                        <v-row>
                          <v-col>
                            <v-switch
                            v-model="factura" @change="validaFactura"
                            :label="factura?'Si requiero Factura':'No requiero Factura'"
                            ></v-switch>
                          </v-col>
                          <v-col v-if="!factura">
                            <v-alert  dense outlined type="warning">
                              Ya no podrás solicitar una factura de esta compra posteriormente.
                            </v-alert>
                          </v-col>
                        </v-row>
                      </v-card-subtitle> 
                    </div> 
                  </div>
                </v-card> 
              </v-col>

              <v-col cols="12">
                <v-card color="#1F7087"  dark v-if="validaCredito && factura" >
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
                    <v-avatar class="ma-3" size="65" tile >
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

            <v-container @click="enaContinueMPay=true" >
              <v-row dense> 
                <v-col cols="12">
                  <v-card color="#C3DDF5">
                    <div class="d-flex flex-no-wrap justify-space-between">
                      <div>
                        <v-card-title class="text-h5">Pago en linea</v-card-title>
                        <v-card-subtitle >
                          Tu pago se acredita al momento.
                        </v-card-subtitle>    
                         <!-- env="sandbox"  -->
                          <PayPal 
                            :amount="total"
                            currency="MXN" 
                            :client="credentials" 
                            :items="payProducts"
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

export default {
  name: "appBuy",
  data() {
    return { 
      sucursalSelec : 0 
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
    this.isLoad = true;  
    await this.validaLogin();
    if (this.isLogged) {
      await this.allSucursales();
      await this.allProductinCar();
      for (let index = 0; index < this.productos.length; index++) { 
        this.payProducts.push(
          {"name": this.productos[index].name
            ,"description": this.productos[index].value
            ,"quantity": this.productos[index].cantidad.toString()
            ,"price": parseFloat(this.productos[index].l0).toFixed(2).toString()
            ,"currency": "MXN" 
          });
          this.saleOrder.productos.push(
          {
            "quantity": this.productos[index].cantidad.toString()
            ,"price": parseFloat(this.productos[index].l0).toFixed(2)
            ,"total": (
                        parseFloat(this.productos[index].l0).toFixed(2) 
                          * 
                        parseFloat(this.productos[index].cantidad).toFixed(2)
                      ).toFixed(2)
            ,"m_product_id":this.productos[index].m_product_id 
            ,"value":this.productos[index].value  
          });
      } 
      this.total = this.totalCarNet().toString();
      this.saleOrder.c_bpartner_id = this.user.c_bpartner_id;
      this.saleOrder.ad_user_id = this.user.ad_user_id;
      this.saleOrder.grandtotal = this.totalCarNet();
      this.saleOrder.status_entrega = "pendiente";  
      this.saleOrder.m_pricelist_id = this.user.m_pricelist_id;
    }else{
      this.menu('/shop/Login/');
    }
    this.isLoad = false;  
    this.isPay = true; 
  }
  ,methods: {
    validaFactura(){
      if(this.factura == false){
        this.methodPay = 0;
        this.enaContinueMPay = true; 
      }
    },
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
        console.log(result.data);
        this.emptyCar();
        return true;
      }else{ 
        this.msgError = result.data;
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
        const OSInsert = await this.insertSaleOrder();
        if (this.saleOrder._id != "" && OSInsert) {
          this.msgSucces = "Pago Procesado Exitosamente, cadena del comprobante: " +this.saleOrder._id;
          this.changeMethodPay();
          this.isPay = false;
          this.isSucursal = true;
        }
        this.isLoad = false;
      } else {
        this.msgError = "El pago no se pudo completar";
        console.log(data);
      } 
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
      ) {
        if (this.saleOrder.method_pay  == "EFE" ) {
          this.sucursalSelec = "";
        }
        this.isPay = false;
        this.isSucursal = true;
      }else{
        this.enaContinueMPay = true; 
      }
    },
    calculaTotalCar_fn(){
      let total = 0;
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          total += parseFloat(element.cantidad) * parseFloat(element.l0);
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
    },totalCarNet(){
        let total = 0;
        for (let index = 0; index < this.productos.length; index++) {
          const element = this.productos[index];
          total += element.cantidad * element.l0;
        }
        return parseFloat(total).toFixed(2);
    },
    creditoDisponible(){
      return parseFloat(this.user.so_creditlimit) - parseFloat(this.user.so_creditused);
    }
  },  
  components: {
      PayPal
  }
  ,computed: {
    validaCredito(){
      if (this.user.socreditstatus == "O") {
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
