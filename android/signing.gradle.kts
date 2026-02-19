val isCiBuild = System.getenv()["CI"]?.toBoolean() == true

android {
    signingConfigs {
        create("release") {
            if (isCiBuild) { // CI=true is exported by Codemagic
                storeFile = file(System.getenv()["CM_KEYSTORE_PATH"])
                storePassword = System.getenv()["CM_KEYSTORE_PASSWORD"]
                keyAlias = System.getenv()["CM_KEY_ALIAS"]
                keyPassword = System.getenv()["CM_KEY_PASSWORD"]
            } else {
                val keystoreProperties = Properties().apply {
                    var file = File("key.properties")
                    if (file.exists()) load(file.reader())
                }
                
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }
    
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
