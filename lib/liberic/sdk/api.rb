module Liberic
  module SDK
    module API
      extend FFI::Library
      ffi_lib Liberic.library_path

      def self.attach_eric_function(name, params, return_type, original_name = nil)
        original_name ||= 'Eric' + name.to_s.capitalize.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }
        attach_function(name, original_name, params, return_type)
      end

      # ERICAPI_IMPORT int STDCALL EricBearbeiteVorgang(
      #     const char* datenpuffer,
      #     const char* datenartVersion,
      #     uint32_t bearbeitungsFlags,
      #     const eric_druck_parameter_t* druckParameter,
      #     const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricTransferHandle* transferHandle,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer,
      #     EricRueckgabepufferHandle serverantwortXmlPuffer);
      attach_eric_function :bearbeite_vorgang, [:string, :string,
          Types::BearbeitungFlag,
          :pointer,
          :pointer,
          :pointer,

          :pointer,
          :pointer], :int


      # ERICAPI_IMPORT int STDCALL EricBeende(void);
      attach_eric_function :beende, [], :int

      # ERICAPI_IMPORT int STDCALL EricChangePassword(const byteChar* psePath, const byteChar* oldPin,
      #     const byteChar* newPin);
      attach_eric_function :change_password, [:string, :string, :string], :int

      # ERICAPI_IMPORT int STDCALL EricPruefeBuFaNummer(const byteChar* steuernummer);
      attach_eric_function :pruefe_bu_fa_nummer, [:string], :int

      # ERICAPI_IMPORT int STDCALL EricCheckXML(const char* xml, const char* datenartVersion,
      #     EricRueckgabepufferHandle fehlertextPuffer);
      attach_eric_function :check_xml, [:string, :string, :pointer], :int, :EricCheckXML

      # ERICAPI_IMPORT int STDCALL EricCloseHandleToCertificate(EricZertifikatHandle hToken);
      attach_eric_function :close_handle_to_certificate, [:uint], :int

      # TODO
      # ERICAPI_IMPORT int STDCALL EricCreateKey(
      #     const byteChar* pin,
      #     const byteChar* pfad,
      #     const eric_zertifikat_parameter_t* zertifikatInfo);
      attach_eric_function :create_key, [:string, :string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricCreateTH(const char* xml, const char* verfahren,
      #     const char* datenart, const char* vorgang,
      #     const char* testmerker, const char* herstellerId,
      #     const char* datenLieferant, const char* versionClient,
      #     const byteChar* publicKey,
      #     EricRueckgabepufferHandle xmlRueckgabePuffer);
      attach_eric_function :create_th, [:string, :string, :string, :string,
          :string, :string, :string, :string, :string, :pointer], :int, :EricCreateTH

      # TODO:
      # ERICAPI_IMPORT int STDCALL EricCreateUUID(
      #     EricRueckgabepufferHandle uuidRueckgabePuffer);

      # ERICAPI_IMPORT int STDCALL EricDekodiereDaten(
      #     EricZertifikatHandle zertifikatHandle,
      #     const byteChar* pin,
      #     const byteChar* base64Eingabe,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :dekodiere_daten, [:uint, :string, :string, :pointer], :int

      attach_eric_function :einstellung_alle_zuruecksetzen, [:void], :int

      # ERICAPI_IMPORT int STDCALL EricEinstellungLesen(
      #     const char* name,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :einstellung_lesen, [:string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricEinstellungSetzen(
      #     const char* name,
      #     const char* wert);
      attach_eric_function :einstellung_setzen, [:string, :string], :int

      # ERICAPI_IMPORT int STDCALL EricEinstellungZuruecksetzen(
      #     const char* name);
      attach_eric_function :einstellung_zuruecksetzen, [:string], :int

      # ERICAPI_IMPORT int STDCALL EricEntladePlugins(
      #     void);
      attach_eric_function :entlade_plugins, [], :int

      # ERICAPI_IMPORT int STDCALL EricFormatStNr(
      #     const byteChar* eingabeSteuernummer,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :format_st_nr, [:string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricGetAuswahlListen(
      #     const char* datenartVersion,
      #     const char* feldkennung,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :get_auswahl_listen, [:string, :string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricGetErrormessagesFromXMLAnswer(
      #     const char* xml,
      #     EricRueckgabepufferHandle transferticketPuffer,
      #     EricRueckgabepufferHandle returncodeTHPuffer,
      #     EricRueckgabepufferHandle fehlertextTHPuffer,
      #     EricRueckgabepufferHandle returncodesUndFehlertexteNDHXmlPuffer);
      attach_eric_function :get_errormessages_from_xml_answer, [:string, :pointer, :pointer, :pointer, :pointer], :int, :EricGetErrormessagesFromXMLAnswer

      # ERICAPI_IMPORT int STDCALL EricGetHandleToCertificate(
      #     EricZertifikatHandle* hToken,
      #     uint32_t* iInfoPinSupport,
      #     const byteChar* pathToKeystore);
      attach_eric_function :get_handle_to_certificate, [:pointer, :pointer, :string], :int

      # ERICAPI_IMPORT int STDCALL EricGetPinStatus(
      #     EricZertifikatHandle hToken,
      #     uint32_t* pinStatus,
      #     uint32_t keyType);
      attach_eric_function :get_pin_status, [:uint, :pointer, :uint], :int

      # ERICAPI_IMPORT int STDCALL EricGetPublicKey(
      #     const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :get_public_key, [:pointer, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricHoleFehlerText(
      #     int fehlerkode,
      #     EricRueckgabepufferHandle rueckgabePuffer);
      attach_eric_function :hole_fehler_text, [:int, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricHoleFinanzaemter(
      #     const byteChar* finanzamtLandNummer,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_finanzaemter, [:string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricHoleFinanzamtLandNummern(
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_finanzamt_land_nummern, [:pointer], :int

      # TODO
      # ERICAPI_IMPORT int STDCALL EricHoleFinanzamtsdaten(
      #     const byteChar bufaNr[5],
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);

      # ERICAPI_IMPORT int STDCALL EricHoleTestfinanzaemter(
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_testfinanzaemter, [:pointer], :int

      # ERICAPI_IMPORT int STDCALL EricHoleZertifikatEigenschaften(
      #     EricZertifikatHandle hToken,
      #     const byteChar * pin,
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :hole_zertifikat_eigenschaften, [:uint, :string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricHoleZertifikatFingerabdruck(
      #     const eric_verschluesselungs_parameter_t* cryptoParameter,
      #     EricRueckgabepufferHandle fingerabdruckPuffer,
      #     EricRueckgabepufferHandle signaturPuffer);
      attach_eric_function :hole_zertifikat_fingerabdruck, [:pointer, :pointer, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricInitialisiere(
      #     const byteChar *pluginPfad,
      #     const byteChar *logPfad);
      attach_eric_function :initialisiere, [:string, :string], :int

      # ERICAPI_IMPORT int STDCALL EricMakeElsterStnr(
      #     const byteChar* steuernrBescheid,
      #     const byteChar landesnr[2+1],
      #     const byteChar bundesfinanzamtsnr[4+1],
      #     EricRueckgabepufferHandle steuernrPuffer);
      # FIXME: non-pointer string
      attach_eric_function :make_elster_stnr, [:string, :string, :string, :pointer], :int

      # ERICAPI_IMPORT int STDCALL EricPruefeBIC(
      #     const byteChar* bic);
      attach_eric_function :pruefe_bic, [:string], :int, :EricPruefeBIC

      # ERICAPI_IMPORT int STDCALL EricPruefeIBAN(
      #   const byteChar* iban);
      attach_eric_function :pruefe_iban, [:string], :int, :EricPruefeIBAN

      # TODO
      # ERICAPI_IMPORT int STDCALL EricPruefeEWAz(
      #     const byteChar* einheitswertAz);

      # ERICAPI_IMPORT int STDCALL EricPruefeIdentifikationsMerkmal(
      #     const byteChar* steuerId);
      attach_eric_function :pruefe_identifikations_merkmal, [:string], :int

      # ERICAPI_IMPORT int STDCALL EricPruefeSteuernummer(
      #     const byteChar* steuernummer);
      attach_eric_function :pruefe_steuernummer, [:string], :int

      # TODO
      # ERICAPI_IMPORT int STDCALL EricPruefeZertifikatPin(
      #    const byteChar *pathToKeystore,
      #    const byteChar *pin,
      #    uint32_t keyType);

      # TODO
      # ERICAPI_IMPORT int STDCALL EricRegistriereFortschrittCallback(
      #     EricFortschrittCallback funktion,
      #     void* benutzerdaten);

      # TODO
      # ERICAPI_IMPORT int STDCALL EricRegistriereGlobalenFortschrittCallback(
      #     EricFortschrittCallback funktion,
      #     void* benutzerdaten);

      # typedef void(STDCALL *EricLogCallback)(
      #         const char* kategorie,
      #         eric_log_level_t loglevel,
      #         const char* nachricht,
      #         void* benutzerdaten);
      callback :log_callback, [:string, :int, :string, :pointer], :void

      # ERICAPI_IMPORT int STDCALL EricRegistriereLogCallback(
      #     EricLogCallback funktion,
      #     uint32_t schreibeEricLogDatei,
      #     void* benutzerdaten);
      attach_eric_function :registriere_log_callback, [:log_callback, :uint, :pointer], :int

      def self.generate_log_callback(&block)
        FFI::Function.new(:void, [:string, :int, :string, :pointer]) do |category, level, message|
          block.call(category, level, message)
        end
      end

      # ERICAPI_IMPORT EricRueckgabepufferHandle STDCALL EricRueckgabepufferErzeugen(
      #     void);
      attach_eric_function :rueckgabepuffer_erzeugen, [], :pointer

      # ERICAPI_IMPORT int STDCALL EricRueckgabepufferFreigeben(
      #     EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_freigeben, [:pointer], :int

      # ERICAPI_IMPORT const char* STDCALL EricRueckgabepufferInhalt(
      #     EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_inhalt, [:pointer], :string

      # ERICAPI_IMPORT uint32_t STDCALL EricRueckgabepufferLaenge(
      #     EricRueckgabepufferHandle handle);
      attach_eric_function :rueckgabepuffer_laenge, [:pointer], :uint

      # ERICAPI_IMPORT int STDCALL EricSystemCheck(
      #     void);
      attach_eric_function :system_check, [], :int

      # ERICAPI_IMPORT int STDCALL EricVersion(
      #     EricRueckgabepufferHandle rueckgabeXmlPuffer);
      attach_eric_function :version, [:pointer], :int
    end
  end
end
