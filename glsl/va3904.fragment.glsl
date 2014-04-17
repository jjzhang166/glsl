#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
vec2 z=(gl_FragCoord.xy/resolution.y-vec2(.5*resolution.x/resolution.y,.5))*4.,p=(mouse-vec2(.5,.5))*4.;

void main(){vec4 c;for(float f=.5;f<4.;f+=.1){if(length(z)>4.){c=vec4(.1,.2,1.,1.)*f;break;}z=vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y)+p;}gl_FragColor=c;}