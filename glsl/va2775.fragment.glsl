// By @paulofalcao
// Blobs
// modded by @simesgreen
// revealed by @psonice_cw

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// returns distance to point
float makePoint(vec2 x, vec2 f, vec2 s, float t){
   vec2 p = vec2(sin(t*f.x), cos(t*f.y)) * s;
   return length(p - x);
}

vec2 minDist(vec2 mind, float i, float d)
{
   //return min(mind, d);
   return (d < mind.x) ? vec2(d, i) : mind;
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   float t = time*0.2;
   //float t = 10.0;

   vec2 a = vec2(1e10, 0);
   a = minDist(a, 1.0, makePoint(p, vec2(3.3,2.9), vec2(0.1,0.1), t));
   a = minDist(a, 2.0, makePoint(p, vec2(1.9,2.0), vec2(0.4,0.4), t));
   a = minDist(a, 3.0, makePoint(p, vec2(0.8,0.7), vec2(0.4,0.5), t));
   a = minDist(a, 4.0, makePoint(p, vec2(2.3,0.1), vec2(0.6,0.3), t));
   a = minDist(a, 5.0, makePoint(p, vec2(0.8,1.7), vec2(0.5,0.4), t));
   a = minDist(a, 6.0, makePoint(p, vec2(0.3,1.0), vec2(0.4,0.4), t));
   a = minDist(a, 7.0, makePoint(p, vec2(1.4,1.7), vec2(0.4,0.5), t));
   a = minDist(a, 8.0, makePoint(p, vec2(1.3,2.1), vec2(0.6,0.3), t));
   a = minDist(a, 9.0, makePoint(p, vec2(1.8,1.7), vec2(0.5,0.4), t));   

   a = minDist(a, 10.0, makePoint(p, vec2(2.7,0.2), vec2(0.1,0.2), t));
   a = minDist(a, 11.0, makePoint(p, vec2(1.5,0.5), vec2(0.3,0.5), t));
   a = minDist(a, 12.0, makePoint(p, vec2(0.9,0.7), vec2(0.7,0.3), t));
   a = minDist(a, 13.0, makePoint(p, vec2(1.8,1.2), vec2(0.1,0.5), t));
   a = minDist(a, 14.0, makePoint(p, vec2(0.1,1.6), vec2(0.9,0.7), t));
   a = minDist(a, 15.0, makePoint(p, vec2(0.7,0.9), vec2(0.3,0.2), t));
   a = minDist(a, 16.0, makePoint(p, vec2(1.1,2.3), vec2(0.4,0.9), t));
   a = minDist(a, 17.0, makePoint(p, vec2(0.4,1.7), vec2(0.3,0.6), t));
   a = minDist(a, 18.0, makePoint(p, vec2(0.6,1.3), vec2(0.5,0.4), t));   

   float i = a.x*2.0;
   //float i = a.y / 18.0;
   //vec3 c = vec3(i, i, i);
   //vec3 c = vec3(sin(a.y)*0.5+0.5, cos(a.y)*0.5+0.5, 1.0);
   vec3 c = mix(vec3(0.5, 0.05, 0.05), vec3(1.0, 0.8, 0.7), a.x*2.0);
   c = mod(c*20., 1.);
   gl_FragColor = vec4(c, 1.0);
}