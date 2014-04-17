// waves
// @simesgreen

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float wave(vec2 p, vec2 w)
{
   return sin(p.x*w.x+time)*w.y;
}

float waveline(vec2 p, float y)
{
   float d = length(y - p.y);
   float i = smoothstep(0.005, 0.0, d);
   //float i = exp(-d*d);
   return i;
}

void main(void)
{
   vec2 p = (gl_FragCoord.xy / resolution)*2.0-1.0;

   //float y = wave(p, vec2(5.0, 0.5));
   //y += wave(p, vec2(11.0, 0.2));
   //y += wave(p, 10.0, 0.1);
	
   //float d = length(y - p.y);	
   //float i = smoothstep(0.01, 0.0, d);

   float i=0.0;	
#if 1
   for(int n=0; n<20; n++) {
   	i += waveline(p, wave(p, vec2(5.0*float(n), 0.5/float(n))) );
        //i += waveline(p, wave(p, vec2(5.0, 1.0/float(n))) );	   
   }
#endif
	
#if 0
   float y = 0.0;
   for(int n=0; n<4; n++) {
        y += wave(p, vec2(10.0*float(n+1), 0.2 / float(n+1)));
   }
   i += waveline(p, y);
#endif

   vec3 c = mix(vec3(0.0, 0.0, 0.0), vec3(0.0, 1.0, 1.0), i*0.5);
	
   //gl_FragColor = vec4(i, i, i, 1.0);
   gl_FragColor = vec4(c, 1.0);
}