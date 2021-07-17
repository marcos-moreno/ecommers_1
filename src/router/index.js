import Vue from 'vue'
import VueRouter from 'vue-router' 
import config from '../json/config.json' 

Vue.use(VueRouter)

const routes = [
   { path: '/', redirect: 'shop',}
//  /*
  ,{ path: '/shop/',redirect: '/shop/Home',  }
  ,{ path: '/shop/Home', name: 'Home',component: () => import('../views/Home.vue')}
  ,{ path: '/shop/Buy', name: 'Buy',component: () => import('../views/Buy.vue')}
  ,{ path: '/shop/Home/:pagina', name: 'HomePage',props: true,component: () => import('../views/Home.vue')}
  ,{ path: '/shop/Account', name: 'Account',component: () => import('../views/Account.vue')}
  ,{ path: '/shop/Login',name: 'Cuenta',component: () => import('../views/Login.vue')}
  ,{ path: '/shop/product/:value/:origen/:pagina',name: 'Producto',props: true,component:()=>import('../views/Producto.vue')}
  ,{ path: '/shop/shopingcar/',name: 'Shopingcar',props: true,component: () => import('../views/Shopingcar.vue')}
  ,{ path: '/shop/purchases/',name: 'Purchases',props: true,component: () => import('../views/Purchases.vue')}
  ,{ path: '/shop/ChangePassword/',name: 'ChangePassword',props: true,component: () => import('../components/ChangePassword.vue')}
  
  ,{ path: '/shop/Foro/',name: 'Foro',props: true,component: () => import('../views/Foro.vue')}

  ,{ path: '/shop/AvisoPrivacidad/',name: 'AvisoPrivacidad',props: true,component: () => import('../views/Avisoprivacidad.vue')}

  ,{ path: '/shop/deliveries', name: 'Deliveries',component: () => import('../views/Deliveries.vue')}
  ,{ path: '/shop/Suggestions/',name: 'Suggestions',props: true,component: () => import('../views/Suggestions.vue')}
  ,{ path: '/shop/Forum/',name: 'Forum',props: true,component: () => import('../views/Forum.vue')}
  ,{ path: '/shop/Novedades/',name: 'Novedades',props: true,component: () => import('../views/Novedades.vue')}

  
// */
  ,{ path: '/shop/register/',name: 'preRegistro',props: true,component: () => import('../views/pre-registro.vue')}
  
  // Admin
  ,{ path: '/shop/admin'+config.matchAdmin+'/login',name: 'LoginAdmin',props: true,component: () => import('../views/admin/LoginAdmin.vue')}
  ,{ path: '/shop/admin'+config.matchAdmin+'/HomeAdmin',name: 'HomeAdmin',props: true,component: () => import('../views/admin/HomeAdmin.vue')}
  ,{ path: '/shop/admin'+config.matchAdmin+'/ForumAdmin',name: 'ForumAdmin',props: true,component: () => import('../views/admin/ForumAdmin.vue')}
  ,{ path: '/shop/admin'+config.matchAdmin+'/ComplaintsSuggestionsAdmin',name: 'ComplaintsSuggestionsAdmin',props: true,component: () => import('../views/admin/ComplaintsSuggestionsAdmin.vue')}
  ,{ path: '/shop/admin'+config.matchAdmin+'/SeguimientoPedido/',name: 'SeguimientoPedido',props: true,component: () => import('../views/generic/SeguimientoPedido.vue')}

  //Generic
  ,{ path: '/shop/Logout/',name: 'Logout',props: true,component: () => import('../components/Logout.vue')}
  ,{ path: '/:pathMatch(.*)*',name: 'Not Found',component: () => import('../components/NotFound.vue')}
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
