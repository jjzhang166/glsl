#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float noise(vec2 p, float s)
    {
      return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
    }
    float mix2(float a2, float b2, float t2)
    { return mix(a2,b2,t2*t2*(3.-2.*t2)); }
    float fracnoise(vec2 p, float s, float c)
    {
      float sum = .0;
      for(float i=0. ;i<6.; i+=1.)
      {
        vec2 pi = vec2(pow(2.,i+c)), fp = fract(p*pi), ip = floor(p*pi);
        sum += 2.0*pow(.5,i+c)*mix2(mix2(noise(ip, s),noise(ip+vec2(1.,.0), s), fp.x), mix2(noise(ip+vec2(.0,1.), s),noise(ip+vec2(1.,1.), s), fp.x), fp.y);
      }
      return sum*(2.2-c);
    }
    vec3 fractnoise(vec2 p, float s)
    {
      vec3 sum = vec3(.0);
      for(float i = .0; i<4.; i+=1.)
      {
        sum += fract(vec3(99.9)*vec3(cos(12.9+s*29.8+i*19.9),cos(14.0+s*17.9+i*23.7),cos(12.1+s*22.1+i*24.5)))*vec3(fracnoise(p, s+i, (i+1.0)));
      }
      return sum;
    }



void main( void ) {
	vec2 p=gl_FragCoord.xy/resolution.xy+vec2(6.001,5.0);
	gl_FragColor=vec4(fractnoise(p,765.0),1.0);

}

	

