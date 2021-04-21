import Vue from 'vue'
import VueRouter from 'vue-router'
// import Home from '../views/Home.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/shop/',
    name: 'Inicio', 
    component: () => import('../views/Home.vue')
  },
  {
    path: '/shop/Home',
    name: 'Home', 
    component: () => import('../views/Home.vue')
  },
  {
    path: '/shop/about',
    name: 'About', 
    component: () => import('../views/About.vue')
  },
  {
    path: '/shop/product/:value',
    name: 'Producto',
    props: true, 
    component: () => import('../views/Producto.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
