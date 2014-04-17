#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define M_PI 3.14159265358979323846
//old ass learning glsl type shader from somewhere. Pretty generic and universal way of making a circle though. Softened it up, changed some stuff. -gtoledo  
//uniform float size;
  void main(void)
 {
	 //adding in some deform to the simple dots-gt
	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    	vec2 m = -1.0 + 2.0 * mouse.xy *1.;

    	float a1 = atan(p.y-m.y,p.x-m.x);
    	float r1 = sqrt(dot(p-m,p-m));
    	float a2 = atan(p.y+m.y,p.x+m.x);
    	float r2 = sqrt(dot(p+m,p+m));

	vec2 uv;
    	uv.x = 0.2*time + (r1-r2)*1.25;
    	uv.y = sin(2.0*(a1-a2));

    float w = r1*r2*0.8;
   // vec3 col = texture2D(tex0,uv).xyz;

   // gl_FragColor = vec4(col/(.1+w),1.0);
	 
	 
	 
	 
      vec2 pos = (mod(resolution * uv-(mouse*resolution.x), vec2(50.0)) - vec2(25.0));
      float dist_squared = dot(pos, pos);
  
     gl_FragColor = mix(vec4(.90, .90, .90, 1.0), vec4(0.0, 0.0, 0.0, 1.0),
                        smoothstep(1.0, resolution.x/2., dist_squared));
 }

