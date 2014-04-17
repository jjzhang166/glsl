#ifdef GL_ES
precision mediump float;
#endif

// weyland yutani remixed @paulofalcao blobshader

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy){
   float xx = x+sin(time*fx)*.5;
   float yy = y+cos(time*fy)*.5;
   return 15.0/sqrt(xx*xx+yy*yy);
}

void main(void) {
   vec2 position = ( gl_FragCoord.xy / resolution.xy )-0.5;

   float x = position.x*2.0;
   float y = position.y*2.0;

   float a = makePoint(x,y,3.3,3.2) + makePoint(x,y,3.9,3.0);
   float b = makePoint(x,y,3.2,2.9) + makePoint(x,y,2.7,2.7);
   float c = makePoint(x,y,2.4,3.3) + makePoint(x,y,2.8,2.3);
   
   vec3 d = vec3(a,b,c)/60.0;
   
   gl_FragColor = vec4(d.x,d.y,d.z,1.0);
}