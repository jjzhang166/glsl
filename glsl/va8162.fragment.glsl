#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}


// Uniforms : data shared by every shader
uniform mat4 model;
uniform mat4 view;
uniform vec3 cameraPosition;
uniform mat4 projection;
uniform vec3 dragonPosition;

uniform sampler2D textureUnitDiffuse;
uniform sampler2D textureUnitSpecular;
uniform sampler2D textureUnitNormal;
uniform sampler2D textureUnitDisplacement;

#ifdef _VERTEX_

// Attributes : per vertex data
in vec4 vertexPosition;
in vec3 vertexNormal;
in vec2 vertexUv;
in vec4 vertexColor;


// Varyings : data to transmit to fragments
out vec2 uv;
out vec3 normal;
out vec3 position;

void main(void)
{	
	uv = vertexUv;
	normal = normalize(vec3(model * vec4(vertexNormal * texture(textureUnitNormal, uv).rgb, 0.0)));
	//position = vec3(model * vertexPosition);
	// gl_Position = projection * view * model * vertexPosition;

	vec3 dv = texture( textureUnitDisplacement, vertexUv ).xyz;
	float dfx = 0.05* dv.x;
	vec3 displacedPosition = normal.x * dfx + vertexPosition.xyz;

	position = vec3(model * vec4(displacedPosition, 1.));
	gl_Position = projection * view * model * vec4( displacedPosition, 1.0 );
}

#endif

#ifdef _FRAGMENT_

// Varyings : data receved and interpolated from the vertex shaders
in vec2 uv;
in vec3 normal;
in vec3 position;

// Final output
out vec4 fragColor;
out vec4 fragNormal;

vec3 pointLight(in vec3 lcolor, in float intensity, in vec3 lpos, in vec3 n, in vec3 fpos, vec3 diffuse, float spec, vec3 cpos)
{
	vec3 l =  lpos - fpos;
	vec3 v = fpos - cpos;
	vec3 h = normalize(l-v);
	float n_dot_l = clamp(dot(n, l), 0, 1.0);
	float n_dot_h = clamp(dot(n, h), 0, 1.0);
	float d = distance(l, fpos);
	float att = clamp( 1.0 / ( 1 + 0.1 * (d*d)), 0.0, 1.0);
	vec3 color = lcolor * intensity * att * (diffuse * n_dot_l  + spec * vec3(1.0, 1.0, 1.0) *  pow(n_dot_h, spec * 100.0));
	return color;
}

vec3 directionalLight(in vec3 lcolor, in float intensity, in vec3 ldir, in vec3 n, in vec3 fpos, vec3 diffuse, float spec, vec3 cpos)
{
	vec3 l = ldir;
	vec3 v = fpos - cpos;
	vec3 h = normalize(l-v);
	float n_dot_l = clamp(dot(n, -l), 0, 1.0);
	float n_dot_h = clamp(dot(n, h), 0, 1.0);
	float d = distance(l, fpos);
	vec3 color = lcolor * intensity * (diffuse * n_dot_l + spec * vec3(1.0, 1.0, 1.0) *  pow(n_dot_h, spec * 100.0));
	return color;
}

vec3 spotLight(in vec3 lcolor, in float intensity, in vec3 ldir, in vec3 lpos, in vec3 n, in vec3 fpos, vec3 diffuse, float spec, vec3 cpos)
{
	vec3 l =  lpos - fpos;
	float cosTs = dot( normalize(-l), normalize(ldir) ); 
	float thetaP =  radians(30.0);
	float cosTp = cos(thetaP);      
	vec3 v = fpos - cpos;
	vec3 h = normalize(l-v);
	float n_dot_l = clamp(dot(n, l), 0, 1.0);
	float n_dot_h = clamp(dot(n, h), 0, 1.0);
	float d = distance(l, fpos);
	vec3 color = vec3(0.0, 0.0, 0.0);
	if (cosTs > cosTp) 
		color = pow(cosTs, 30.0) * lcolor * intensity * (diffuse * n_dot_l + spec * vec3(1.0, 1.0, 1.0) *  pow(n_dot_h, spec * 100.0));
	return color;
}

void main(void)
{
	vec3 diffuse = texture(textureUnitDiffuse, uv).rgb;
	float spec = texture(textureUnitSpecular, uv).r;

	vec3 cpointlight1 = pointLight(vec3(0.2, 0.2, .6), 4, vec3(0.0, 0.1, 0.0), normal, position, diffuse.rgb, spec, cameraPosition);
	//vec3 cpointlight2 = pointLight(vec3(1.0, 1.0, 1.0), 5, dragonPosition, normal, position, diffuse.rgb, spec, cameraPosition);
	vec3 cdirlight1 = directionalLight(vec3(0.8, 0.8, 0.8), 1, vec3(0.0, -1.0, 0.0), normal, position, diffuse.rgb, spec, cameraPosition);
	//vec3 cspotlight1 = spotLight(vec3(1.0, 1.0, 1.0), 1., dragonDirection * - 1, dragonPosition, n, position, diffuse, spec, cameraPosition );

	fragColor = vec4( cpointlight1 + cdirlight1 /*+ cspotlight1*/, spec);
	fragNormal = vec4(normal, spec);


}

#endif