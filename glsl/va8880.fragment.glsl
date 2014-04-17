#ifdef GL_ES
precision mediump float;
#endif


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 cursorPos;
	vec2 screen_center;
	
	vec3 ViewDirection;
	
	ViewDirection = vec3 (.0,.0,-1.0);
	
	float mov_radius;
	
	mov_radius = min(resolution.x, resolution.y)*0.5;	
	screen_center = resolution * 0.5;
	
	cursorPos = mouse.xy * resolution.xy;
	
	/***********************************************************/
	/* Geometry                                                */
	/***********************************************************/
	float Sphere_radius;
	
	vec3  SurfaceNormal;
	vec3  SurfacePosition;
	vec3  Sphere_center;
	vec2  tmpv2;
	
	float dist_from_center;
	
	Sphere_radius = min(resolution.x, resolution.y)*0.1;
	Sphere_center = vec3(screen_center.x + mov_radius*0.5*sin(time), screen_center.y + mov_radius*0.5*cos(time),.0);
	

	tmpv2 = Sphere_center.xy - gl_FragCoord.xy;
	dist_from_center = length(tmpv2);
	
	float surfaceZ = sqrt(Sphere_radius*Sphere_radius - dist_from_center*dist_from_center);
	
	

	if (dist_from_center < Sphere_radius) { 
		SurfacePosition = vec3(gl_FragCoord.xy,
			       sqrt(Sphere_radius*Sphere_radius - dist_from_center*dist_from_center));
		SurfaceNormal = (SurfacePosition - Sphere_center)/Sphere_radius;

	} else {
		SurfacePosition = vec3(gl_FragCoord.xy, .0);
		SurfaceNormal = vec3(.0, .0, 0.5);
	}

        /***********************************************************/
	/* Lighting                                                */
	/***********************************************************/
	
	vec3 LightColor;
	vec3 SpecularLightColor[3];
	vec3 DiffuseLightColor[3];
	vec3 AmbientLightColor;
	
	float DiffuseLightIntensity;
	float SpecularLightIntensity;
	float AmbientLightIntensity;
	
	DiffuseLightColor[0] = vec3(0.8,0.5,0.2);
	SpecularLightColor[0] = vec3(0.5,0.3,0.3);
	
	DiffuseLightColor[1] = vec3(0.2,0.2,0.8);
	SpecularLightColor[1] = vec3(0.3,0.2,0.5);
	
	DiffuseLightColor[2] = vec3(0.6,0.8,0.2);
	SpecularLightColor[2] = vec3(0.2,0.5,0.3);
	
	AmbientLightColor = vec3(0.05,0.2,0.05);
	
	vec3 LightPosition[3];
	vec3 LightDirection;
	vec3 SpecularDirection;
	
	LightColor = vec3(.0,.0,.0);
	
	LightPosition[0] = vec3(cursorPos, Sphere_radius*3.0);
	LightPosition[1] = vec3(screen_center.x + cos(time*1.02) * mov_radius, screen_center.y - cos(time*1.02)*mov_radius, Sphere_radius*8.0);
	LightPosition[2] = vec3(screen_center.x - sin(time*0.999) * mov_radius, screen_center.y + sin(time*1.021)*mov_radius, Sphere_radius*1.0*(1.0+cos(time)));
	
	for (int i=0; i<3; i++) {
		LightDirection = normalize(LightPosition[i] - SurfacePosition);
		
		/***********************************************************/
		/* Diffuse Light                                           */
		/***********************************************************/
		
		DiffuseLightIntensity = dot(LightDirection, SurfaceNormal);
		
		/***********************************************************/
		/* Specular Light                                          */
		/***********************************************************/
		
		SpecularDirection = LightDirection - 2.0 * SurfaceNormal * dot(LightDirection, SurfaceNormal);
	
		SpecularLightIntensity = dot(ViewDirection, SpecularDirection);
		SpecularLightIntensity *= SpecularLightIntensity*SpecularLightIntensity;
		SpecularLightIntensity *= SpecularLightIntensity*SpecularLightIntensity;
		
		LightColor += DiffuseLightColor[i] * DiffuseLightIntensity +
		             SpecularLightColor[i] * SpecularLightIntensity;
		
		AmbientLightIntensity += DiffuseLightIntensity;
	}
	
	
	/***********************************************************/
	/* Ambient Light                                           */
	/***********************************************************/
	
	AmbientLightIntensity = 1.0 - AmbientLightIntensity;
	if (AmbientLightIntensity < .0) {
		AmbientLightIntensity =.0;
	} else {
		AmbientLightIntensity *= AmbientLightIntensity;
	}
	 
	
	/***********************************************************/
	/* Lighting Finalizing                                     */
	/***********************************************************/
	LightColor += AmbientLightIntensity * AmbientLightColor;
	
	gl_FragColor = vec4(LightColor,1.0);
	
}