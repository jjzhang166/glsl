#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

float intersect(in vec3 ro, in vec3 rd){

	float r = 1.0;
	//float a = dot(rd, rd); //nao precisa pq vai ser sempre 1.0 ja que rd sao normalizados
	float b = 2.0*dot(rd, ro);
	float c = dot(ro,ro) - r*r;
	float delta = b*b - 4.0*c;
	if (delta < 0.0)
		return 0.0;
	float x1 = (-b - sqrt(delta)) / 2.0;
	float x2 = (-b + sqrt(delta)) / 2.0;

	return x1;
}

void main() {


	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 ro = vec3(0.0, 0.0, 2.0);
	vec3 rd = normalize(vec3( (-1.0 + 2.0*uv), -1.0  ));

	float result = intersect(ro, rd);

	vec4 outcolor = vec4(0.0, 0.0, 0.0, 1.0);

	vec3 lightcolor = vec3(0.0, 0.9, 0.2);
	vec3 spherecolor = vec3(0.8, 0.3, 0.2);

	if ( result > 0.0 ){	

		vec3 point = ro + result*rd;
		vec3 spherepos = vec3(0.0, 1.0, 0.0);
		vec3 normal = point - spherepos;
//		vec3 lightpos = normalize( vec3( 1.0, cos(time)+0., 5.0));	
		vec3 lightpos = vec3(1.0, cos(time)*2.0, 5.0);

		float diffuse = max(0.0, dot(normal, normalize(lightpos - point)));
		float attenuation = 1.0 - smoothstep(0.0, 10.0, length(lightpos - point));
		diffuse = diffuse * attenuation;

		outcolor = vec4( lightcolor*diffuse + spherecolor , 1.0);
	}
	
	gl_FragColor = outcolor;
}