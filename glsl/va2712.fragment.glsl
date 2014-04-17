#ifdef GL_ES
precision mediump float;
#endif
//what's uTime??? 
uniform float time;
uniform vec2 resolution;

vec3 noise(in vec2 cord, in float scale)
{
	//cord*=scale;
	//return fract(sin(dot(vec2(14850.23435098,3239.209),vec2(594.021,168596.24))/10.0));
vec4 f;
  f = fract( exp( fract(vec4(cord,-cord)) )*666.0 );
  f = fract( log( f + 3.0)*999.0 );
  f = f*f*vec4(1.0,1.0,-2.7182818284590452353602874713527,-2.7182818284590452353602874713527);
vec3 v,v2,v3;
  v.xy = f.xy+f.wz + 2.7182818284590452353602874713527;
  v.z = v.x+v.y;
  v = fract(v);
  v2=v*v;
  v3=v2*v;

 f.x = dot(
        vec4(1.0,v.x,v2.x,v3.x)
       ,vec4(1.1,-0.381818181818181818181024,+0.54545454545454545454432,-0.36363636363636363636288)
      );
 f.y = dot(
        vec4(1.0,v.y,v2.y,v3.y)
       ,vec4(1.1,-0.381818181818181818181024,+0.54545454545454545454432,-0.36363636363636363636288)
      );
 f.z = dot(
        vec4(1.0,v.z,v2.z,v3.z)
       ,vec4(1.1,-0.381818181818181818181024,+0.54545454545454545454432,-0.36363636363636363636288)
      );
return f.xyz/scale;

	
	//return vec3(fract(cos(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453)/scale);
	
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy/resolution.xy;
	vec2 cc = (uv-vec2(0.5))*vec2(1.6,1.0);
	vec3 col = vec3(0.0);
	
	float grad = 0.0;
	float z = 0.0;
	float fade = 0.0;
	vec2 star = vec2(0.0,0.0);
	vec2 blob = vec2(0.0,0.0);
	for (float i=0.0;i<1024.0;i++)
	{
		star = vec2(128.0*cos(i),-16.0*atan(i));
		z = mod(i*i-214.0*time,1024.0);
		blob = star/z;
		//grad = pow(sin(cc.x*cc.y*time+cc.x*time),0.1);
		grad += (z/1280000.0)/pow(length(cc-blob),0.9);
	}
	//grad+=0.4*grad*(1.0+sin(time*11.7));
	col = vec3(grad*2.0,grad,grad/2.0)+noise(vec2(gl_FragCoord*sin(time)),32.);
	//col = vec3(1.0-grad,0.8-grad,1.0-grad);
	
	gl_FragColor = vec4(col,1.0);
}