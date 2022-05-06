varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
// Part G
varying vec3 pos;
varying vec3 varN;

uniform sampler2D texture;
// Part C
uniform float texScale;


// Part G
uniform vec4 color;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec4 LightPosition;
uniform float Shininess;

void main()
{
    // Part C texture movement
    gl_FragColor = color * texture2D( texture, texCoord * texScale );

    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Part F
    float distance = sqrt(Lvec[0]*Lvec[0] + Lvec[1]*Lvec[1] + Lvec[2]*Lvec[2]);
    float scaleDist = 1.0/(distance*distance);

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize(varN);

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    // Part F
    color.rgb = globalAmbient + scaleDist*(ambient + diffuse + specular);
    color.a = 1.0;
}
